//to use stats display, you need ASL Var Viewer(https://github.com/hawkerm/LiveSplit.ASLVarViewer)

state("REZ")
{
    int area: 0x004BE128, 0x10;
    int layer: 0x004BE068, 0x510;
    float bossHealth: 0x9f83c0, 0x194;
    int menuState: 0x005877D0, 0x20, 0x68, 0xB8;
    int gameState: 0x005879C8, 0xF0;
    int supSpawned: 0x559F84;
    int supObtained: 0x559F8C;
    int enemySpawned: 0x525308;
    int enemyShotDown: 0x52530C;
    int layerAnalyzable: 0x559f74;
    int layerAnalyzed: 0x559f7c;
}

state("REZAX-Win64-Shipping")
{
    int layerAX: 0x2B69210, 0x8, 0xFC;
    int bossStateAX: 0x2DEE6C0, 0x10, 0x8, 0x100, 0x370, 0x3A0;
}

startup
{
    settings.Add("directassault", false, "Category: direct assault");
    settings.Add("any", true, "Category: any%");
    settings.Add("hundred", false, "Category: 100%");
    settings.Add("layer", true, "Split on every layer");
    settings.Add("boss", true, "Split on starting a boss fight");
    settings.Add("bossdead", true, "Split on defeating a boss (even if unchecked, it splits on the end of run according to category)");
    settings.Add("area", true, "Split on entering a new area");
    settings.Add("fourbosses", false, "Split on defeating every sub-boss in front of EDEN (Area 5)");
    vars.axreset = false;
}

init
{
    vars.analyzation = "-%";
    vars.shotDown = "-.--%";
    vars.supportItem = "-.--%";
}

update
{
    if(game.ProcessName == "REZ"){
        if(current.layerAnalyzable == 0){
            vars.analyzation = "-%";
        }else{
            vars.analyzation = 
            Math.Round((float)current.layerAnalyzed/(float)current.layerAnalyzable*100f).ToString() + "%";
        }
        if(current.enemySpawned == 0){
            vars.shotDown = "-.--%";
        }else{
            vars.shotDown =
            Math.Round((float)current.enemyShotDown/(float)current.enemySpawned*100f,2).ToString("f") + "%";
        }
        if(current.supSpawned == 0){
            vars.supportItem = "-.--%";
        }else{
            vars.supportItem =
            Math.Round((float)current.supObtained/(float)current.supSpawned*100f,2).ToString("f") + "%";
        }
    }
}

start
{
    if(game.ProcessName == "REZ"){
        if(current.gameState == 8 && current.area == 1 && old.area == 0){
            vars.axreset = false;
            return true;
        }
    }else if(game.ProcessName == "REZAX-Win64-Shipping"){
        return true;
    }
}

split
{
    if(game.ProcessName == "REZ"){
        if(current.gameState == 8){
            if(current.layer == old.layer+1 
            && current.area > 0 && current.area < 5 && current.layer <= 10){
                return settings["layer"];
            }
            if(current.area != 3 && current.area < 5 && current.layer > 10 && current.bossHealth == 1f && old.bossHealth == 0f){
                return settings["boss"];
            }
            if(current.area == 3 && current.layer == 18 && old.layer != 18){
                return settings["boss"];
            }
            if(current.layer == 18 && current.bossHealth == 0f && old.bossHealth > 0f){
                return settings["bossdead"] || current.area == 4 && settings["any"];
            }

            if(current.area > old.area){
                return true;
            }
            if(current.area == 6){
                if(current.bossHealth == 1f && old.bossHealth == 0f){
                    return current.layer >= 8;
                }
                if(current.bossHealth == 0f && old.bossHealth > 0f){
                    return settings["fourbosses"] || current.layer >= 8;
                }
            }
        }
    }else{
        if(current.layerAX == old.layerAX+1){
            return true;
        }
        if(current.layerAX == 7 && current.bossStateAX == 5 && old.bossStateAX != 5){
            return true;
        }
    }
}

reset
{
    if(game.ProcessName == "REZ"){
        if(vars.axreset){
            vars.axreset = false;
            return true;
        }
        if(current.menuState == 3 && old.menuState == 1){
            return true;
        }
        if(settings["directassault"] && current.gameState == 10 && old.gameState == 8){
            return true;
        }
    }
}

exit
{
    vars.axreset = true;
}