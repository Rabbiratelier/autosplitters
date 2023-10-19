state("Soft_Body")
{
    int puzzleNumber: 0x00875258, 0x0;
    int sceneCounter: 0x0079AE28, 0x4;
    int enemyCounter: 0x007ABA48, 0xC;
}

init
{
    vars.resetable = true;
    vars.sceneEnding = false;
    vars.origin = 0;
}

update
{
    if(!vars.resetable && current.puzzleNumber != 1){
        vars.resetable = true;
        if(current.puzzleNumber == 92){
            vars.origin = current.enemyCounter-1;
            vars.sceneEnding = false;
        }
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
    if(old.puzzleNumber != 1 && current.puzzleNumber > old.puzzleNumber){
        if(current.puzzleNumber == 92){
            vars.origin = current.enemyCounter-1;
            vars.sceneEnding = false;
        }
        return true;
    }
    if(current.puzzleNumber == 92 && current.sceneCounter > old.sceneCounter){
        if(vars.origin == current.enemyCounter){
            return true;
        }else{
            vars.sceneEnding = true;
        }
    }
    if(current.puzzleNumber == 92 && old.enemyCounter != current.enemyCounter && vars.origin == current.enemyCounter && vars.sceneEnding){
        return true;
    }
}

reset
{
    if(vars.resetable && current.puzzleNumber == 1){
        return true;
    }
}