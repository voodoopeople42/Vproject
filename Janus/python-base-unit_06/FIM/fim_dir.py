# fim_dir.py
import os

path = os.getcwd()
print(path)

dirs = os.listdir(path +'/repo')

# This would print all the files and directories
for file in dirs:
   print(file)

print(os.listdir(path +'/repo'))
for file in [item for item in dirs if os.path.isfile(item)]:
  print("file name: ", file)
