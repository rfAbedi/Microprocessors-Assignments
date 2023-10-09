DATA1 DB 0

CoSeg segmant 
    MOVE AH, 1
    INT 21H
BACK:
    MOV SA, 0
    
    LOOP BACK
    MOV AH, 4CH
    INT 21H
CoSeg ends