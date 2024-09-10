## Introduction to Setting Up Homebound
This guide assumes the software is being installed from scratch. While it aims to cover as many scenarios as possible, addressing every unique situation is nearly impossible. Therefore, you may need to look up solutions or find ways to make it work for any specific issues that may arise. Consider this guide as a general outline rather than a step-by-step manual to follow blindly.

So, without further delay, let’s get started with the steps:
1. [Getting Started](#getting-started) (installing dependencies)
2. [Generating SSH Keys](#generating-ssh-keys)
3. [Setting Up Remote Repository](#setting-up-remote-repository)
4. [Setting Up Server Software](#setting-up-server-software)
5. [Setting Up Client Software](#setting-up-client-software)

> [!NOTE]
> The difficulty level of setting up this software is comparable to setting up a remote Git repository using the SSH authentication method.

## Getting Started

Before setting up Homebound, it’s essential to install the necessary software dependencies. You’ll need to install Git and an SSH server or client. Additionally, the software will run in a Bash environment.

- [Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

#### Installing SSH on Windows 10/11
- Settings > System > Optional Features > Add a feature > OpenSSH Client and OpenSSH Server > Install

> [!NOTE]
> SSH comes pre-installed on most Linux distributions and the latest versions of macOS. These systems also run Bash software through the terminal. When you install Git on Windows, it typically includes Git Bash, allowing you to run the software on Windows as well.

> [!TIP]
> To ensure your SSH services start automatically, you can configure them to launch at startup. The setup process will vary depending on your operating system.

## Generating SSH Keys

You can generate the keys using the terminal by following the instructions. You are free to generate new keys or use existing ones, managing them with your preferred methods.

#### Check if you already have generated SSH keys:
```
ls -al ~/.ssh
```

#### Generate a new SSH key. -C "custom_key_comment" is optional, if you want your key to be more recognizeable.
```
ssh-keygen -t rsa -b 4096 -C "custom_key_comment"
```

#### Start an SSH agent & add your key
```
ssh-keygen -t rsa -b 4096 -C "custom_key_comment"
```

> [!TIP]
> Use the default name (id_rsa) for Git to recognize your SSH key automatically without SSH agent. For convenience and automatic connection, leave the passphrase empty.


## Setting Up Remote Repository

## Setting Up Server Software

## Setting Up Client Software
