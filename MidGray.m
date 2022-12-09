function
x=imread();
[r,g,b]=imsplit(x);
se=strel("disk",2);
g=adapthisteq(g,'NumTiles',[15 15],'ClipLimit',0.02);
lmin=imerode(g,se);
lmax=imdilate(g,se);
mg=(lmin+lmax)/2;
mg=imadjust(mg);
z=imbinarize(mg);
z=~z;
sk=bwmorph(z,"thin",inf);
