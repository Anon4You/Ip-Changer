# 🌐 IP Changer 🔄

A powerful and easy-to-use tool to change your IP address automatically using **Tor** and **Privoxy**. Perfect for privacy enthusiasts, developers, and anyone who needs to rotate their IP address frequently.

![Termux](https://img.shields.io/badge/Termux-000000?style=for-the-badge&logo=termux&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Tor](https://img.shields.io/badge/Tor-7D4698?style=for-the-badge&logo=tor-project&logoColor=white)
![License](https://img.shields.io/badge/License-BSD--3--Clause-blue?style=for-the-badge)

---

## 🚀 Features

- **Automatic IP Rotation**: Change your IP address at regular intervals.
- **Multiple Tor Instances**: Run multiple Tor instances for better performance.
- **Privoxy Integration**: Route your traffic through Privoxy for HTTP/HTTPS support.
- **Customizable Rotation Time**: Set your preferred IP rotation interval.
- **Lightweight**: Designed to run efficiently on Termux and other Linux environments.

---

## 🛠 Installation

### Method 1: Using `curl` (Manual Installation)

You can install the **IP Changer** tool with a single command:

```bash
curl -sL https://github.com/Anon4You/Ip-Changer/raw/main/installer.sh | bash
```

This will:
1. Install all dependencies (`tor`, `privoxy`, `curl`, `netcat-openbsd`).
2. Download the `ip-changer` script.
3. Move it to `$PREFIX/bin` and make it executable.

### Method 2: Using Alienkrishn Termux Repository

If you have added the **Alienkrishn Termux Repository**, you can install the tool using `apt`:

1. Add the Alienkrishn Termux Repository: [Alienkrishn Termux Repository](https://anon4you.github.io/alienkrishn)
2. Install the IP Changer tool:
   ```bash
   apt install ip-changer
   ```

---

## 🛠 Usage

### Basic Usage

- Start the IP changer with the default rotation time (10 seconds):
  ```bash
  ip-changer
  ```

- Set a custom rotation time (minimum 5 seconds):
  ```bash
  ip-changer -r 15
  ```

### Options

- `-r SECONDS`: Set the IP rotation interval (default: 10 seconds).
- `-h`: Display the help message.

---

## 📝 Example

```bash
$ ip-changer -r 20
Starting multitor and privoxy server...
Renewing Tor circuit to change IP...
New IP: 123.456.789.101
Next IP change in 20 seconds...
```

---

## 🛑 Stopping the Tool

To stop the IP changer, press `Ctrl + C` in the terminal. This will terminate all Tor and Privoxy processes.

---

## 🤝 Contributing

Contributions are welcome! If you have any ideas, improvements, or bug fixes, feel free to open an **issue** or submit a **pull request**.

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add your message here"
   ```
4. Push to the branch:
   ```bash
   git push origin feature/your-feature-name
   ```
5. Open a pull request.

---

## 📜 License

This project is licensed under the **BSD-3-Clause License**. See the [LICENSE](LICENSE) file for details.

---

## 🙏 Credits

- Developed by [Anon4You](https://github.com/Anon4You).
- Inspired by the need for privacy and anonymity.

---

## 📬 Contact

For questions or feedback, feel free to reach out:

- **GitHub**: [Anon4You](https://github.com/Anon4You)
- **Email**: alienkrishn@gmail.com

---

Enjoy rotating your IP address like a pro! 🎉
