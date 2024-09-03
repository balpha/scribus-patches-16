# Overview

This repository is a collection of patches that I apply on top of my version of [Scribus](http://www.scribus.net/canvas/Scribus) to add a few features I miss. Feel free to use them as well, but be aware that they are very specific to the way I use Scribus, and that they **should be considered incomplete** (e.g. missing undo/redo functionality, sub-par UI, etc.)

This is a work-in-progress port of my old patches to a modern version (1.6.2 at the time of writing) of Scribus. You can find the originals at https://github.com/balpha/scribus-patches-13.

# Description of the patches

### Show soft hyphen in the story editor

Since I like to tightly control the hyphenation of text, I often manually add soft hyphens (U+00AD) to my text. These characters are usually invisible, which makes this manual work hard to manage. This patch makes the soft hypens visible inside the story editor by displaying them as red dashes (similar to how other special characters like frame breaks are displayed).

### Load drop shadows from 1.3 / 1.4 files

I have been using drop shadows (I called them "soft shadows") for over a decade in Scribus 1.3 and 1.4 using my patches. That functionality was eventually added natively to Scribus (based on my patch) in Scribus 1.5, but of course when loading a file that was created with an old version, current Scribus doesn't load the drop shadow data because in "real" old files, this feature didn't exist yet.

This patch updates the scribus134 loader to also load drop shadow data, so that I can load my old files correctly. 

### Auto contrast

This patch adds a new image effect called "Auto contrast".

The default settings for this effect do almost precisely the same thing as [GIMP's "auto white balance"](https://docs.gimp.org/2.10/en/gimp-layer-white-balance.html). Discarding (thus clipping) the top and bottom 0.5% of the pixels, it stretches the red, green, and blue color channels to the full range. This can do magic to enhance photographs, in particular when they're tinted towards a certain color. And it can also do horrible things, depending on the image, so be sure to look at the actual result.

The effect has a few options:

- *Threshold low* and *Threshold high*: This is the percentage of the image's pixels that are discarded when calculating the range of color values. As mentioned above, the default is 0.5% for both, but this can be adjusted indepently for dark (low) and light (high) values. If, for example, your photo has a large over-exposed area (that you may be cropping away anyway), you'll probably want to increase the high threshold.

- *Sync colors*: If this is checked, then instead of adjusting the color channels independently, the low and high values will be identical for all three color channels (using the lowest low value and the highest high value). This means that there will be no color correction (or distortion); rather this will just increase the image contrast.

- *Amount*: Controls the strenght of the effect from 100% (the default) to 0% (no change at all).

This effect only works on RGB images. Frankly, I've never used CMYK images, and I have now idea how I would treat them for applying this effect. In particular this means that this effect **won't do anything when exporting CYMK PDFs unless you also apply the "effects before color management" patch** (see its description for the reason).

This is not technically a **file format change**, however I have not tested how Scribus behaves when a file contains an unknown image effect. Thus opening and/or re-saving a .sla file that contains this effect with an unpatched version of Scribus may have unintended consequences.

### Apply image effects before color management

When using color management, Scribus applies image effects *after* converting the image to the target colorspace. This is very unfortunate, because it makes image effects combined with color management (especially soft proofing) utterly useless. There's a [very old bug report on this matter](https://bugs.scribus.net/view.php?id=4270).

This patch changes this order; image effects are applied on the original image data as loaded from the file; only then are any color conversions applied. Scribus' loading of TIFF and PSD files is a bit special here; color conversion happens at the same time as loading the image. I don't know the reasoning behind this, and right now this is only partially handled. If you work with TIFF or PSD files, you probably don't want to use this.

If you use both color management and image effects, this patch is a **major change**, and it's not hidden behind a setting -- all your files will suddenly behave differently. So make very sure you want to apply it.

# License

Scribus itself is copyright 2001–2024 Franz Schmid and rest of the members of the Scribus Team and for the most part licensed under GPLv2+. See their file [COPYING](https://github.com/scribusproject/scribus/blob/master/COPYING) for details.

These patches ("the program") are copyright 2008-2024 Benjamin Dumke-von der Ehe.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.