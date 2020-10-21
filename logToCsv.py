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
            datas = row.split(" ")
            myList = []    
            for data in datas : 
                value = data.split("=")
                if(value[0]=="mean_time") :
                    mean_time = value[1]
                    mean_time = mean_time[:-1]
                    myList.append(mean_time)     
                else : 
                    myList.append(value[1])
                
            print(myList)
            writer.writerow(myList)


        
