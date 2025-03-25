import sys
import os
import cv2
import numpy as np
from PyQt6.QtWidgets import QApplication, QWidget, QPushButton, QVBoxLayout, QLabel
from PyQt6.QtGui import QScreen
from PyQt6.QtCore import Qt
import pyautogui

class ScreenshotApp(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()
        self.screenshot_dir = ""
        self.screenshot_count = 0
        self.capturing = False

    def initUI(self):
        layout = QVBoxLayout()
        
        self.label = QLabel("Click 'Start' to capture and circle regions of interest.")
        layout.addWidget(self.label)
        
        self.start_button = QPushButton("Start", self)
        self.start_button.clicked.connect(self.start_capture)
        layout.addWidget(self.start_button)
        
        self.end_button = QPushButton("End", self)
        self.end_button.clicked.connect(self.end_capture)
        layout.addWidget(self.end_button)
        
        self.setLayout(layout)
        self.setWindowTitle("Interactive Screenshot Capturer")
        self.setGeometry(100, 100, 300, 150)

    def start_capture(self):
        self.screenshot_dir = os.path.join(os.getcwd(), "screenshots")
        os.makedirs(self.screenshot_dir, exist_ok=True)
        self.screenshot_count = 0
        self.capturing = True
        self.capture_area()
    
    def capture_area(self):
        while self.capturing:
            screenshot = pyautogui.screenshot()
            screenshot = cv2.cvtColor(np.array(screenshot), cv2.COLOR_RGB2BGR)
            
            points = self.get_circles()
            if points is None:
                continue
            
            mask = np.zeros(screenshot.shape[:2], dtype=np.uint8)
            for center, radius in points:
                cv2.circle(mask, center, radius, 255, -1)
            
            result = cv2.bitwise_and(screenshot, screenshot, mask=mask)
            
            filename = os.path.join(self.screenshot_dir, f"screenshot_{self.screenshot_count}.png")
            cv2.imwrite(filename, result)
            self.screenshot_count += 1
            
    def get_circles(self):
        circles = []
        drawing = False
        center = None
        
        def mouse_callback(event, x, y, flags, param):
            nonlocal drawing, center
            if event == cv2.EVENT_LBUTTONDOWN:
                drawing = True
                center = (x, y)
            elif event == cv2.EVENT_MOUSEMOVE and drawing:
                radius = int(((x - center[0])**2 + (y - center[1])**2) ** 0.5)
                temp_img = img.copy()
                cv2.circle(temp_img, center, radius, (0, 255, 0), 2)
                cv2.imshow("Draw Circles", temp_img)
            elif event == cv2.EVENT_LBUTTONUP:
                drawing = False
                radius = int(((x - center[0])**2 + (y - center[1])**2) ** 0.5)
                circles.append((center, radius))
        
        screenshot = pyautogui.screenshot()
        img = cv2.cvtColor(np.array(screenshot), cv2.COLOR_RGB2BGR)
        
        cv2.namedWindow("Draw Circles")
        cv2.setMouseCallback("Draw Circles", mouse_callback)
        
        while True:
            cv2.imshow("Draw Circles", img)
            if cv2.waitKey(1) & 0xFF == 27:
                break
        
        cv2.destroyAllWindows()
        return circles if circles else None
    
    def end_capture(self):
        self.capturing = False
        self.label.setText("Capture ended.")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    ex = ScreenshotApp()
    ex.show()
    sys.exit(app.exec())
