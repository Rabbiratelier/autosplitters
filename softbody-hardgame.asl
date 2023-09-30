state("Soft_Body")
{
    int puzzleNumber: 0x00875258, 0x0;
    int sceneCounter: 0x0079AE28, 0x4;
}

init
{
    vars.resetable = true;
}

update
{
    if(!vars.resetable &&current.puzzleNumber == 68){
        vars.resetable = true;
    }
}

start
{
    if(current.puzzleNumber == 1 && current.sceneCounter == old.sceneCounter+1){
        vars.resetable = false;
        return true;
    }
}

split
{
    if(current.puzzleNumber != 68 && current.puzzleNumber > old.puzzleNumber || current.puzzleNumber == 92 && current.sceneCounter > old.sceneCounter){
        return true;
    }
}

reset
{
    if(vars.resetable && current.puzzleNumber == 1
    || old.puzzleNumber == 1 && current.puzzleNumber != 1 && current.puzzleNumber != 68){
        return true;
    }
}