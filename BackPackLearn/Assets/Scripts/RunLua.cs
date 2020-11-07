using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SLua;
using System.IO;

[CustomLuaClass]
public class RunLua : MonoBehaviour {

    public LuaState state;

    private void Start()
    {
        //state = new LuaState();    

        //state.loaderDelegate = ((string fn, ref string absoluteFn) =>
        //{
        //    string file_Path = Directory.GetCurrentDirectory() + "/Assets/Scripts/SLua/" + fn;
        //    Debug.Log(file_Path);
        //    return File.ReadAllBytes(file_Path);
        //});

        //state.doFile("packMgr.lua");

        LuaSvr svr = new LuaSvr();

        LuaSvr.mainState.loaderDelegate += ((string fn, ref string absoluteFn) =>
        {
            string file_Path = Directory.GetCurrentDirectory() + "/Assets/Scripts/SLua/" + fn;
            Debug.Log(file_Path);
            return File.ReadAllBytes(file_Path);
        });

        svr.init(null, () => // 如果不用init方法初始化的话,在Lua中是不能import的
        {
            svr.start("packMgr.lua");
        });
    }
}
