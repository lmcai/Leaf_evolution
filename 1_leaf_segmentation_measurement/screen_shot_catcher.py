import sys
import pyautogui
from PyQt6.QtWidgets import QApplication, QWidget
from PyQt6.QtGui import QPainter, QPen, QPolygon
from PyQt6.QtCore import Qt, QPoint

class ScreenshotTool(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Irregular Screenshot Tool")
        self.setWindowOpacity(0.4)
        self.setWindowFlag(Qt.WindowType.FramelessWindowHint)
        self.setWindowState(self.windowState() | Qt.WindowState.FullScreen)
        self.points = []
        self.drawing = True

    def mousePressEvent(self, event):
        if event.button() == Qt.MouseButton.LeftButton:
            self.points.append(event.pos())
        elif event.button() == Qt.MouseButton.RightButton and len(self.points) > 2:
            self.drawing = False
            self.captureScreenshot()
            self.close()

    def paintEvent(self, event):
        if self.drawing and self.points:
            painter = QPainter(self)
            painter.setPen(QPen(Qt.GlobalColor.red, 2, Qt.PenStyle.SolidLine))
            for i in range(len(self.points) - 1):
                painter.drawLine(self.points[i], self.points[i + 1])

    def captureScreenshot(self):
        if len(self.points) < 3:
            return
        
        x_min = min(p.x() for p in self.points)
        y_min = min(p.y() for p in self.points)
        x_max = max(p.x() for p in self.points)
        y_max = max(p.y() for p in self.points)
        
        screenshot = pyautogui.screenshot(region=(x_min, y_min, x_max - x_min, y_max - y_min))
        screenshot.save("screenshot.png")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    tool = ScreenshotTool()
    tool.show()
    sys.exit(app.exec())
