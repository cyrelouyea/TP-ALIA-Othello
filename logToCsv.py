import csv
import sys
import os


with open('logs.csv', 'a', newline='') as file:
    if(len(sys.argv)>1):
        filename = sys.argv[1]
        writer = csv.writer(file)  
        if(os.stat('logs.csv').st_size==0) : 
            writer.writerow(["player", "h1", "h2","h3", "depth" , "games", "wins","draws","win_rate","draw_rate","lose_rate","mean_time"])
        
        f = open(filename, "r")
        for row in f:
            row = row.strip().replace('\n', '')
            datas = row.split(" ")
            myList = []    
            for data in datas : 
                value = data.split("=")
                myList.append(value[1])
                
            writer.writerow(myList)


        
