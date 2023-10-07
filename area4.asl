//to use stats display, you need to install ASL Var Viewer(https://github.com/hawkerm/LiveSplit.ASLVarViewer)

state("REZ")
{
    int area: 0x004BB108, 0x10;
    int layer: 0x004BB048, 0x550;
    int layerAlt: 0x004C2D68, 0x0;
    float bossHealth: 0x004B7108, 0x0;
    int menuState: 0x005847B0, 0x20, 0x68, 0xB8;
    int gameState: 0x005849A8, 0xF0;
    int supSpawned: 0x556F64;
    int supObtained: 0x556F6C;
    int enemySpawned: 0x5222E8;
    int enemyShotDown: 0x5222EC;
    int layerAnalyzable: 0x556f54;
    int layerAnalyzed: 0x556f5c;
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
}

init
{
    vars.analyzation = "-%";
    vars.shotDown = "-.--%";
    vars.supportItem = "-.--%";
}

update
{
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

start
{
    if(current.gameState == 8 && current.area == 4 && old.area == 0){
        return true;
    }
}

split
{
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
}

reset
{
    if(current.menuState == 3 && old.menuState == 1){
        return true;
    }
    if(settings["directassault"] && current.gameState == 10 && old.gameState == 8){
        return true;
    }
}