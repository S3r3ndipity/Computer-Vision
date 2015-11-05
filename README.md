# Computer-Vision
Computer Vision Projects
A very brief description: Often cropping and uniformly resizing images are not the ideal way to shrink an image. Content-Aware Image Resizing allows one to intelligently remove the least important parts of an image first. It computes an energy function over the image and removes the seams from lowest to highest energy. This algorithm can easily be extended to allow for enlarging images and protecting/erasing certain regions of the image. The tool that I made allows the user to load any reasonably sized image and shrink or enlarge it with a drag of the slider. The software also displays the seams that it is removing/adding for a very visually informative effect.

Instructions:
1. Run GuiMAC('bears.jpg') on a Macbook in MATLAB, which should open up a GUI that allows you to play around with the software.
2. Press the "PreCompute" button and look at the MATLAB command line to see when it finishes (it should probably take about 2 minutes).
3. Press the "Setup" button after it is done precomputing. After a few seconds, the top left image should display a heatmap of the energy function.
4. Then drag the sliders (either horizontally or vertically but not both) to resize the image.
5. You can also use the "Protect" and "Erase" buttons to draw bounding boxes over the image (on the right). After doing steps 2 and 3 again, you will see that resizing the image will now take these regions to be protected or erased into account.
6. You can play around with the other images in the /data folder to see for which images this algorithm works well
