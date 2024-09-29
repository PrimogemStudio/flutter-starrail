#include "flutter_window.h"

#include <iomanip>
#include <optional>
#include <sstream>
#include <thread>
#include <flutter/standard_method_codec.h>

#include "flutter/generated_plugin_registrant.h"

using namespace flutter;

FlutterWindow::FlutterWindow(const DartProject& project)
	: project_(project) {}

FlutterWindow::~FlutterWindow() {}

static std::string format_time() {
	auto now = std::chrono::system_clock::now();
	std::time_t now_time = std::chrono::system_clock::to_time_t(now);
	std::tm now_tm;
	(void)localtime_s(&now_tm, &now_time);
	std::ostringstream oss;
	oss << std::put_time(&now_tm, "%Y-%m-%d %H:%M:%S");
	return oss.str();
}

bool FlutterWindow::OnCreate() {
	if (!Win32Window::OnCreate()) {
		return false;
	}

	RECT frame = GetClientArea();

	// The size here must match the window dimensions to avoid unnecessary surface
	// creation / destruction in the startup path.
	flutter_controller_ = std::make_unique<FlutterViewController>(
		frame.right - frame.left, frame.bottom - frame.top, project_);
	// Ensure that basic setup of the controller was successful.
	if (!flutter_controller_->engine() || !flutter_controller_->view()) {
		return false;
	}
	RegisterPlugins(flutter_controller_->engine());
	SetChildContent(flutter_controller_->view()->GetNativeWindow());

	flutter_controller_->engine()->SetNextFrameCallback([&]() {
		this->Show();
		});

	// Flutter can complete the first frame before the "show window" callback is
	// registered. The following call ensures a frame is pending to ensure the
	// window is shown. It is a no-op if the first frame hasn't completed yet.
	flutter_controller_->ForceRedraw();
	channel_ = std::make_unique<MethodChannel<>>(flutter_controller_->engine()->messenger(), "MainPage.Event", &StandardMethodCodec::GetInstance());
	std::thread([channel = channel_.get()] {
		while (true)
		{
			std::this_thread::sleep_for(std::chrono::seconds(3));
			channel->InvokeMethod("addMsg", std::make_unique<EncodableValue>("Platform message " + format_time()));
		}
	}).detach();
	return true;
}

void FlutterWindow::OnDestroy() {
	if (flutter_controller_) {
		flutter_controller_ = nullptr;
	}

	Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
	WPARAM const wparam,
	LPARAM const lparam) noexcept {
	// Give Flutter, including plugins, an opportunity to handle window messages.
	if (flutter_controller_) {
		std::optional<LRESULT> result =
			flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
				lparam);
		if (result) {
			return *result;
		}
	}

	switch (message) {
	case WM_FONTCHANGE:
		flutter_controller_->engine()->ReloadSystemFonts();
		break;
	}

	return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
