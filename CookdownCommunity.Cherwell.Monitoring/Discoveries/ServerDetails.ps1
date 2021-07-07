param ([String]$sourceID, [String]$managedEntityID, [String]$principalName)

$api = new-object -comObject 'MOM.ScriptAPI'
$discoveryData = $api.CreateDiscoveryData(0, $SourceId, $ManagedEntityId)

$api.LogScriptEvent("CherwellDiscovery", 2501, 0, "Performing Cherwell Discovery")

[XML]$trebuchetSettings = gc "C:\ProgramData\Trebuchet\trebuchet.settings"

$serverDetails = $discoveryData.CreateClassInstance("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellServerInstallation']$")
$serverDetails.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $principalName)
$serverDetails.AddProperty("$MPElement[Name='System!System.Entity']/DisplayName$", $principalName)
$serverDetails.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellServerInstallation']/InstallServer$", $principalName)
$serverDetails.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellServerInstallation']/HostMode$", $trebuchetSettings.Trebuchet.ServerSetup.HostMode.ToString())
$serverDetails.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellServerInstallation']/Protocol$", $trebuchetSettings.Trebuchet.ServerSetup.Protocol.ToString())
$serverDetails.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellServerInstallation']/Port$", [Int]$trebuchetSettings.Trebuchet.ServerSetup.Port.ToString())
$serverDetails.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellServerInstallation']/ServerName$", $trebuchetSettings.Trebuchet.ServerSetup.ServerName.ToString())
$serverDetails.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellServerInstallation']/SecurityMode$", $trebuchetSettings.Trebuchet.ServerSetup.SecurityMode.ToString())
$serverDetails.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellServerInstallation']/Connection$", $trebuchetSettings.Trebuchet.ServerSetup.Connection.ToString())
$serverDetails.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellServerInstallation']/LogFilePath$", $trebuchetSettings.Trebuchet.ServerSetup.LogFilePath.ToString())
$serverDetails.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellServerInstallation']/LogToLogServer$", $trebuchetSettings.Trebuchet.ServerSetup.LogToLogServer.ToString())
$serverDetails.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellServerInstallation']/SettingsVersion$", [Int]$trebuchetSettings.Trebuchet.SettingsVersion.ToString())


$discoveryData.AddInstance($serverDetails)

[XML]$trebuchetConnectionSettings = gc "C:\ProgramData\Trebuchet\Connections.xml"

foreach($connectionDefinition in $trebuchetConnectionSettings.Trebuchet.ConnectionDefList.ChildNodes)
{
    if($connectionDefinition.SubType -eq "Db")
    {
        # Create a DB connection
        $dbConnection = $discoveryData.CreateClassInstance("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.SqlConnection']$")
        $dbConnection.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $principalName)
		$dbConnection.AddProperty("$MPElement[Name='System!System.Entity']/DisplayName$", ($connectionDefinition.Name + " Connection"))
		$dbConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellServerInstallation']/InstallServer$", $principalName)
        $dbConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.ConnectionDefinition']/Name$", $connectionDefinition.Name)
        $dbConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.ConnectionDefinition']/Version$", $connectionDefinition.Version)
        $dbConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.ConnectionDefinition']/Source$", $connectionDefinition.Source)
        $dbConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.ConnectionDefinition']/LastModified$", $connectionDefinition.LastModDateTime)
        $dbConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.ConnectionDefinition']/ID$", $connectionDefinition.ID)
        $dbConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.ConnectionDefinition']/Disabled$", $connectionDefinition.Disabled)
        $dbConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.ConnectionDefinition']/Scope$", $connectionDefinition.Scope)
        $dbConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.SqlConnection']/ConnectionString$", $connectionDefinition.ConnectionString)
        $dbConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.SqlConnection']/RecoveryMode$", $connectionDefinition.RecoveryMode)
        
		$discoveryData.AddInstance($dbConnection)

		$Relationship = $discoveryData.CreateRelationshipInstance("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellInstallationHostsConnection']$")
		$Relationship.Source = $serverDetails
		$Relationship.Target = $dbConnection
		$discoveryData.AddInstance($Relationship)
    }

    if($connectionDefinition.SubType -eq "PresumedWcfServer")
    {
        # Create a wcf connection
        $wcfConnection = $discoveryData.CreateClassInstance("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.WcfServer']$")
        $wcfConnection.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $principalName)
		$wcfConnection.AddProperty("$MPElement[Name='System!System.Entity']/DisplayName$", ($connectionDefinition.Name + " Connection"))
		$wcfConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellServerInstallation']/InstallServer$", $principalName)
        $wcfConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.ConnectionDefinition']/Name$", $connectionDefinition.Name)
        $wcfConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.ConnectionDefinition']/Version$", $connectionDefinition.Version)
        $wcfConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.ConnectionDefinition']/Source$", $connectionDefinition.Source)
        $wcfConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.ConnectionDefinition']/LastModified$", $connectionDefinition.LastModDateTime)
        $wcfConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.ConnectionDefinition']/ID$", $connectionDefinition.ID)
        $wcfConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.ConnectionDefinition']/Disabled$", $connectionDefinition.Disabled)
        $wcfConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.ConnectionDefinition']/Scope$", $connectionDefinition.Scope)
        $wcfConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.WcfServer']/Soap$", $connectionDefinition.Soap)
        $wcfConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.WcfServer']/Rest$", $connectionDefinition.Rest)
        $wcfConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.WcfServer']/AppServerHostMode$", $connectionDefinition.AppServerHostMode)
        $wcfConnection.AddProperty("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.WcfServer']/URL$", $connectionDefinition.URL)

        $discoveryData.AddInstance($wcfConnection)

		$Relationship = $discoveryData.CreateRelationshipInstance("$MPElement[Name='CookdownCommunity.Cherwell.Monitoring.CherwellInstallationHostsConnection']$")
		$Relationship.Source = $serverDetails
		$Relationship.Target = $wcfConnection
		$discoveryData.AddInstance($Relationship)
    } 
}


$discoveryData