import sys
import os
import cv2
import numpy as np
from PyQt6.QtWidgets import QApplication, QWidget, QPushButton, QVBoxLayout, QLineEdit, QLabel
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
        
        self.label = QLabel("Enter directory name:")
        layout.addWidget(self.label)
        
        self.textbox = QLineEdit(self)
        layout.addWidget(self.textbox)
        
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
        dir_name = self.textbox.text().strip()
        if not dir_name:
            self.label.setText("Please enter a directory name!")
            return
        
        self.screenshot_dir = os.path.join(os.getcwd(), dir_name)
        os.makedirs(self.screenshot_dir, exist_ok=True)
        self.screenshot_count = 0
        self.capturing = True
        self.capture_area()
    
    def capture_area(self):
        while self.capturing:
            screenshot = pyautogui.screenshot()
            screenshot = cv2.cvtColor(np.array(screenshot), cv2.COLOR_RGB2BGR)
            
            points = self.get_polygon()
            if points is None:
                continue
            
            mask = np.zeros(screenshot.shape[:2], dtype=np.uint8)
            cv2.fillPoly(mask, [np.array(points)], (255))
            result = cv2.bitwise_and(screenshot, screenshot, mask=mask)
            
            filename = os.path.join(self.screenshot_dir, f"screenshot_{self.screenshot_count}.png")
            cv2.imwrite(filename, result)
            self.screenshot_count += 1
            
    def get_polygon(self):
        points = []
        
        def mouse_callback(event, x, y, flags, param):
            if event == cv2.EVENT_LBUTTONDOWN:
                points.append((x, y))
            elif event == cv2.EVENT_RBUTTONDOWN and len(points) > 2:
                cv2.destroyWindow("Draw Shape")
        
        cv2.namedWindow("Draw Shape")
        cv2.setMouseCallback("Draw Shape", mouse_callback)
        
        while True:
            temp_img = np.zeros((600, 800, 3), dtype=np.uint8)
            for i in range(len(points) - 1):
                cv2.line(temp_img, points[i], points[i + 1], (0, 255, 0), 2)
            if len(points) > 1:
                cv2.line(temp_img, points[-1], points[0], (0, 255, 0), 2)
            
            cv2.imshow("Draw Shape", temp_img)
            if cv2.waitKey(1) & 0xFF == 27:
                break
        
        cv2.destroyAllWindows()
        return points if len(points) > 2 else None
    
    def end_capture(self):
        self.capturing = False
        self.label.setText("Capture ended.")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    ex = ScreenshotApp()
    ex.show()
    sys.exit(app.exec())
