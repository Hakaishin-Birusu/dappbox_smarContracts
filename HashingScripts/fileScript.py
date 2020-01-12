# import hashlib module
import hashlib

def hash_file(filename):

   # make a hash object
   h = hashlib.sha256()

   # open file for reading in binary mode
   with open(filename,'rb') as file:

       # loop till the end of the file
       chunk = 0
       while chunk != b'':
           # read only 4096 bytes at a time
           chunk = file.read(4096)
           h.update(chunk)

   # return the hex representation of digest
   res = h.hexdigest()
   res2 = "0x"+ res
   return res2

message = hash_file("Enter the file name here and run the script")
print(message)
