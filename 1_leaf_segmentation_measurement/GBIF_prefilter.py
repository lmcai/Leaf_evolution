import os
import tkinter as tk
from tkinter import messagebox
from PIL import Image, ImageTk
import requests
from io import BytesIO

a=open('occurrence.tsv').readlines()
b=open('multimedia.tsv').readlines()

aa=[l.split('\t')[0] for l in a]
bb=[l.split('\t')[0] for l in b]

z=[i for i in aa if i in bb]

out=open('Euphrasia.occurrence.tsv','w')
for l in a:
	if l.split('\t')[0] in z:d=out.write(l)

out.close()

out=open('Euphrasia.multimedia.tsv','w')
for l in b:
	if l.split('\t')[0] in z:d=out.write(l)

out.close()


#Input
x=open('Euphrasia.occurrence.tsv').readlines()
y=open('Euphrasia.multimedia.tsv').readlines()


sp=list(set([l.split('\t')[201] for l in x[1:]]))
sp_gbifID={}
gbifID_URL={}

for l in y[1:]:
	gbifID_URL[l.split()[0]]=l.split('\t')[3]

for l in x[1:]:
	if l.split('\t')[201] in sp_gbifID.keys():
		sp_gbifID[l.split('\t')[201]].append(l.split()[0])
	else:
		sp_gbifID[l.split('\t')[201]]=[l.split()[0]]
		
#randomly select 20 images for each species to coarsely determine if they are good for leafmachine
cml=[]
for i in list(sp_gbifID.keys())[2:]:
	# List of image URLs to process
	print(i)
	#root = tk.Tk()
	#app = ImageReviewer(root, i, sp_gbifID[i])
	#root.mainloop()
	spp=i.replace(" ", "_")
	if len(sp_gbifID[i])<100:
		for j in sp_gbifID[i]:
			cml.append('wget -O '+spp+'_'+j+'.jpg '+gbifID_URL[j])
	else:
		for j in range(0,100):
			cml.append('wget -O '+spp+'_'+sp_gbifID[i][j]+'.jpg '+gbifID_URL[sp_gbifID[i][j]])
	
out=open('download_url.sh','w')
out.write('\n'.join(cml))

###############################
#Abandoned function
class ImageReviewer:
    def __init__(self, root, spp, gbifIDs):
        self.root = root
        self.root.title("Image Reviewer")
        self.spp = spp  # Species name
        self.gbifIDs = gbifIDs  # List of gbifIDs
        self.urls = [gbifID_URL[j] for j in gbifIDs]  # Map gbifIDs to URLs
        self.current_index = 0
        self.saved_count = 0  # Track number of saved images
        self.max_saves = 20  # Stop when 20 images are saved
        self.output_dir = "filtered_images"
        os.makedirs(self.output_dir, exist_ok=True)
        # Create UI Elements
        self.image_label = tk.Label(self.root)
        self.image_label.pack()
        self.yes_button = tk.Button(self.root, text="Yes", command=self.save_image)
        self.yes_button.pack(side=tk.LEFT, padx=10, pady=10)
        self.no_button = tk.Button(self.root, text="No", command=self.next_image)
        self.no_button.pack(side=tk.RIGHT, padx=10, pady=10)
        # Display the first image
        self.load_image()
    def load_image(self):
        """Load and display the current image."""
        if self.saved_count >= self.max_saves:
            messagebox.showinfo("Done", "20 images saved. Stopping the program.")
            self.root.quit()
            return
        if self.current_index >= len(self.urls):
            messagebox.showinfo("Done", "All images processed.")
            self.root.quit()
            return
        url = self.urls[self.current_index]
        try:
            response = requests.get(url, timeout=5)
            response.raise_for_status()
            image = Image.open(BytesIO(response.content))
            image.thumbnail((500, 500))
            self.photo = ImageTk.PhotoImage(image)
            self.image_label.config(image=self.photo)
        except requests.RequestException:
            messagebox.showwarning("Error", f"Failed to load image: {url}")
            self.next_image()
    def save_image(self):
        """Save the image with a unique gbifID and move to the next."""
        if self.saved_count >= self.max_saves:
            return  # Stop saving if the limit is reached
        url = self.urls[self.current_index]
        gbif_id = self.gbifIDs[self.current_index]  # Correctly reference the gbifID
        try:
            response = requests.get(url, timeout=5)
            response.raise_for_status()
            image = Image.open(BytesIO(response.content))
            save_path = os.path.join(self.output_dir, f"{self.spp}_{gbif_id}.jpg")
            image.save(save_path)
            self.saved_count += 1
            # Stop if we've reached 20 saved images
            if self.saved_count >= self.max_saves:
                messagebox.showinfo("Done", "20 images saved. Stopping the program.")
                self.root.quit()
                return
        except requests.RequestException:
            messagebox.showwarning("Error", f"Failed to save image: {url}")
        self.next_image()
    def next_image(self):
        """Move to the next image."""
        self.current_index += 1
        self.load_image()

# Output
output_dir = "filtered_images"
os.makedirs(output_dir, exist_ok=True)
