#!/bin/bash

main(){

	if  [[ "$config" == "" ]]; then
		config="~/NuGet.config"
		echo "Note: config path defaulting to $config"
	fi
	if [[ ! -f $config ]]; then
		echo '<?xml version="1.0" encoding="utf-8"?><configuration/>' > $config
	fi

	if [[ "$owner" == "" ]]; then
		owner=${GITHUB_REPOSITORY%%/*}	
		echo "Note: owner defaulting to $owner"
	fi

	if [[ "$name" == "" ]]; then
		name=GitHub-$owner
		echo "Note: source name defaulting to $name"
	fi

	if [[ "$token" == "" ]]; then
		token=$GITHUB_TOKEN
		echo "Note: using github token."
	fi
	if  [[ "$repositoryLink" == "" ]]; then
		repositoryLink="https://nuget.pkg.github.com/$owner/index.json"
		echo "Note: fallback nuget repository link to  $repositoryLink"
	fi
	if [[ "$RUNNER_OS" == "Windows" ]]; then
		if [[ "$force_cleartext_storage" == "true" ]] || [[ -z "$force_cleartext_storage" ]]; then
			extra_args=--store-password-in-clear-text
		else
			extra_args=
		fi
	else
		extra_args=--store-password-in-clear-text
	fi
	echo "Authenticating to $owner NuPkg Source"
	dotnet nuget add source $repositoryLink \
		--configfile $config \
		-n "$name" \
		-u "$owner" \
		-p "$token" \
		$extra_args
}

main
