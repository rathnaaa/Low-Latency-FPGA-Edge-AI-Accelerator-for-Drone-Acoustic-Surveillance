vals=[]

with open("../rtl_weights/b3.txt") as f:
    vals.extend(f.read().split())

while len(vals) < 2:
    vals.append("00")

with open("../rtl_weights/b3_fixed.txt","w") as f:
    for v in vals[:2]:
        f.write(v+"\n")

print("b3_fixed created")