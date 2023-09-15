using System.IO;
using UnityEditor;
using UnityEditor.Callbacks;
using System.Collections;
using System.Collections.Generic;
#if UNITY_IOS
using UnityEditor.iOS.Xcode;
#endif

public class PostXcodeBuild
{

#if UNITY_IOS

    static void addUnityFrameworkBitcodeSetting(string pathToBuiltProject)
    {
        string projPath = pathToBuiltProject + "/Unity-iPhone.xcodeproj/project.pbxproj";
        var pbxProject = new PBXProject();
        pbxProject.ReadFromFile(projPath);

        // UnityFramework
        string target = pbxProject.GetUnityFrameworkTargetGuid();
        pbxProject.SetBuildProperty(target, "ENABLE_BITCODE", "NO");

        File.WriteAllText(projPath, pbxProject.WriteToString());
    }

    [PostProcessBuild]
    public static void SetXcodePlist(BuildTarget buildTarget, string pathToBuiltProject)
    {
        if (buildTarget != BuildTarget.iOS)
        {
            return;
        }

        /*addUnityFrameworkBitcodeSetting*/
        addUnityFrameworkBitcodeSetting(pathToBuiltProject);
    }
#endif
}