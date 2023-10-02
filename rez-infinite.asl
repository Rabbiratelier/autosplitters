state("REZ")
{
    int area: 0x004BB108, 0x10;
    int layer: 0x004BB048, 0x550;
    int layerAlt: 0x004C2D68, 0x0;
    float bossHealth: 0x004B7108, 0x0;
    int menuState: 0x005847B0, 0x20, 0x68, 0xB8;
}

start
{
    if(current.area == 1 && old.area == 0 && current.layerAlt == 0){
        vars.resetable = true;
        return true;
    }
}

split
{
    if(current.area > 0 && current.area < 5 && current.layer <= 10 && current.layer == old.layer+1){
        vars.resetable = false;
        return true;
    }
    if(current.area > 1 && old.area == 0 && current.layerAlt == 0){
        return true;
    }
    if(current.layer == 18 && old.layer == 16){
        return true;
    }
    if(current.layer == 2 && current.layerAlt == 0 && old.layerAlt != 0){
        return true;
    }
    if(current.area == 6 && old.area != 6){
        return true;
    }
}

reset
{
    if(current.menuState == 3 && old.menuState == 1){
        return true;
    }
    if(vars.resetable && current.area == 1 && current.layer == 0 && current.layerAlt != 0 && old.layerAlt == 0){
        return true;
    }
}