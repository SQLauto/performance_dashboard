﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace kCura.PDB.Service.Properties {
    using System;
    
    
    /// <summary>
    ///   A strongly-typed resource class, for looking up localized strings, etc.
    /// </summary>
    // This class was auto-generated by the StronglyTypedResourceBuilder
    // class via a tool like ResGen or Visual Studio.
    // To add or remove a member, edit your .ResX file then rerun ResGen
    // with the /str option, or rebuild your VS project.
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "4.0.0.0")]
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    internal class Resources {
        
        private static global::System.Resources.ResourceManager resourceMan;
        
        private static global::System.Globalization.CultureInfo resourceCulture;
        
        [global::System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        internal Resources() {
        }
        
        /// <summary>
        ///   Returns the cached ResourceManager instance used by this class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Resources.ResourceManager ResourceManager {
            get {
                if (object.ReferenceEquals(resourceMan, null)) {
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("kCura.PDB.Service.Properties.Resources", typeof(Resources).Assembly);
                    resourceMan = temp;
                }
                return resourceMan;
            }
        }
        
        /// <summary>
        ///   Overrides the current thread's CurrentUICulture property for all
        ///   resource lookups using this strongly typed resource class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Globalization.CultureInfo Culture {
            get {
                return resourceCulture;
            }
            set {
                resourceCulture = value;
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Monitoring for backups and database consistency checks on instance {0} suggested one or more databases is at risk. Review the summary below for details. If the information below appears inaccurate, review your monitoring settings in Performance Dashboard.
        ///{1}
        ///{2}
        ///{3}
        ///
        ///This notification is not intended as a replacement for regular review of backups and consistency checks. As part of data loss prevention, partners are responsible for consistent database maintenance and monitoring.
        ///
        ///This is a daily aler [rest of string was truncated]&quot;;.
        /// </summary>
        internal static string BackupDBCC {
            get {
                return ResourceManager.GetString("BackupDBCC", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to The current quarterly score for {0} {1}
        ///
        ///Quarterly: {2}
        ///User Experience: {3}
        ///Infrastructure Performance: {4}
        ///Recoverability/Integrity: {5}
        ///Uptime: {6}
        ///
        ///Weekly: {7}
        ///User Experience: {8}
        ///Infrastructure Performance: {9}
        ///Recoverability/Integrity: {10}
        ///Uptime: {11}
        ///
        ///This is a daily alert from Performance Dashboard. Automatic notifications can be disabled via Performance Dashboard&apos;s configuration page..
        /// </summary>
        internal static string Daily {
            get {
                return ResourceManager.GetString("Daily", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Score-affecting conditions were detected on {0}. If user activity is high, these conditions may impact scores. To improve the score, review the servers listed below. The scores given below are estimates based on current data and may differ from the final score for the hour.
        ///
        ///{1}
        ///
        ///This is an alert from Performance Dashboard. Automatic notifications can be disabled via Performance Dashboard&apos;s configuration page..
        /// </summary>
        internal static string Forecast {
            get {
                return ResourceManager.GetString("Forecast", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to The latest weekly scores for {0} {1}
        ///
        ///{2}
        ///
        ///This is an hourly alert from Performance Dashboard. Automatic notifications can be disabled via Performance Dashboard&apos;s configuration page..
        /// </summary>
        internal static string Hourly_ScoreAlert {
            get {
                return ResourceManager.GetString("Hourly_ScoreAlert", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Your weekly score report for {0} is below.
        ///
        ///Quarterly: {1}
        ///User Experience: {2}
        ///Infrastructure Performance: {3}
        ///Recoverability/Integrity: {4}
        ///Uptime: {5}
        ///
        ///Weekly: {6}
        ///User Experience: {7}
        ///Infrastructure Performance: {8}
        ///Recoverability/Integrity: {9}
        ///Uptime: {10}
        ///
        ///This is a weekly score report from Performance Dashboard. Automatic notifications can be disabled via Performance Dashboard&apos;s configuration page..
        /// </summary>
        internal static string Weekly {
            get {
                return ResourceManager.GetString("Weekly", resourceCulture);
            }
        }
    }
}
