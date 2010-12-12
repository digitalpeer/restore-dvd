Restore DVD
----------------------------------------
This is a buildroot project that creates a Linux based bootable DVD containing a hard drive image 
created by you.  With the resulting DVD, a user can can restore their hard drive using the image 
on the DVD.  It provides a simple menu to the user to restore their PC.  

This is extremely useful to make backups of your own computers or to make it easy for somebody 
less technical to restore their computer without bothering you.


Before You Begin
-----------------------------------------
Creating the image of the original computer is the first step.  This does not directly involve 
this project.  Before doing this, there are a couple considerations to make on the hard drive
you want to image:

 - If doing a new OS install, use a Knoppix CD/DVD to dd if=/dev/zero of=/dev/sda bs=10M to zero 
   out the entire drive.  This will result in better compression.
 - If not doing a new OS install, try to create a file with the rest of the free space full of 
   zeros and then delete it.
 - It can/will take a long time to image the hard drive over the network, especially with large 
   hard drives.

I was able to image a 500GB hard drive with a clean windows install including updates resulting 
in about a 4GB compressed image.


Creating the Hard Drive Image
-----------------------------------------
There are several ways you can do this, but here is a tried and true method.  You need two networked
computers, one to create the image from and one to dump it to over the network.

On the computer you wish to image, put in a Knoppix CD/DVD, connect the computer to a network, 
and run as root:

# listen on port 333 and write the gzip'ed image
$ dd if=/dev/sda | bzip2 -c9 | nc -l 3333

On another Linux PC run the folowing with the IP address of the PC running the Knoppix CD/DVD:

# connects to PC and downloads image
$ nc 192.168.0.99 3333 > image.bz2

or

# gets image.gz and shows byte progress
$ nc 192.168.0.99 3333 | pv -b > image.bz2


Building the DVD
-----------------------------------------
Now that you have an image somewhere on the Linux PC where you'll build buildroot, perform the 
following steps:

 1. Create a symlink to the image in the buildroot folder.
    $ cd restore-dvd
    $ ln -s /tmp/image.bz2 image.bz2
2. Copy the buildroot config file.
    $ cp restore-dvd.config .config
3. Build
    $ make oldconfig
    $ make

The resulting ISO will be at output/images/rootfs.iso9660 and you can now burn that to a DVD.


Notes
-----------------------------------------
There is currently no checking that the image will fit on a DVD. If your hard drive image is around 4GB
or below you should be fine for a single layer DVD.

The project only restores to /dev/sda.  If the hard drive appears somewhere else or you have a complex
configuration such as a raid controller this will not work.
