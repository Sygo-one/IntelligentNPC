// Copyright Epic Games, Inc. All Rights Reserved.

using UnrealBuildTool;

public class IntelligentNPC : ModuleRules
{
	public IntelligentNPC(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;

		PublicDependencyModuleNames.AddRange(new string[] {
			"Core",
			"CoreUObject",
			"Engine",
			"InputCore",
			"EnhancedInput",
			"AIModule",
			"StateTreeModule",
			"GameplayStateTreeModule",
			"UMG",
			"Slate"
		});

		PrivateDependencyModuleNames.AddRange(new string[] { });

		PublicIncludePaths.AddRange(new string[] {
			"IntelligentNPC",
			"IntelligentNPC/Variant_Platforming",
			"IntelligentNPC/Variant_Platforming/Animation",
			"IntelligentNPC/Variant_Combat",
			"IntelligentNPC/Variant_Combat/AI",
			"IntelligentNPC/Variant_Combat/Animation",
			"IntelligentNPC/Variant_Combat/Gameplay",
			"IntelligentNPC/Variant_Combat/Interfaces",
			"IntelligentNPC/Variant_Combat/UI",
			"IntelligentNPC/Variant_SideScrolling",
			"IntelligentNPC/Variant_SideScrolling/AI",
			"IntelligentNPC/Variant_SideScrolling/Gameplay",
			"IntelligentNPC/Variant_SideScrolling/Interfaces",
			"IntelligentNPC/Variant_SideScrolling/UI"
		});

		// Uncomment if you are using Slate UI
		// PrivateDependencyModuleNames.AddRange(new string[] { "Slate", "SlateCore" });

		// Uncomment if you are using online features
		// PrivateDependencyModuleNames.Add("OnlineSubsystem");

		// To include OnlineSubsystemSteam, add it to the plugins section in your uproject file with the Enabled attribute set to true
	}
}
