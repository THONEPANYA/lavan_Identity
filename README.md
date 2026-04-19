# lavan_Identity
Lavan Identity (Server Side)

## 📄 Lavan Identity (Server Side)

**Lavan Identity** is a character registration system for FiveM (ESX) servers with Discord integration and a whitelist system. It allows players to register their identity, sync data from a database, fetch Discord avatars, and automatically receive a configurable starter pack.

---

## 🔧 Features

### 🔹 1. Discord Whitelist Integration

* Automatically retrieves the player's **Discord ID**
* Checks data from the `lavan_whitelist` database
* Returns:

  * Discord name
  * First name / Last name
  * Date of birth
  * Gender
  * Height

---

### 🔹 2. Discord Avatar Fetching

* Uses Discord API (`/users/{id}`)
* Fetches player avatar in real-time
* Falls back to default avatar if none is set

---

### 🔹 3. Character Registration System

When a player registers:

* Saves data into the `users` database

* Updates:

  * firstname
  * lastname
  * dateofbirth
  * sex
  * height

* Applies data to ESX:

  * Full in-game name
  * Player metadata

---

### 🎁 4. Starter Pack System

Fully configurable starter rewards for new players:

#### 💰 Money

* Cash
* Bank balance

#### 🎒 Items

Example:

* Phone
* Bread
* Water

You can easily customize items and amounts.

---

## ⚙️ Configuration

### 🔑 Discord Bot Token

```lua
local BotToken = ""
```

> Insert your Discord Bot Token to enable avatar fetching

---

### 🎁 Starter Pack

```lua
local StarterPack = {
    giveMoney = true,
    money = 5000,
    bank = 50000,

    giveItems = true,
    items = {
        {name = 'phone', count = 1},
        {name = 'bread', count = 5},
        {name = 'water', count = 5}
    }
}
```

---

## 🔄 Workflow

1. Player joins the server
2. System retrieves Discord ID
3. Checks whitelist database
4. Sends data to client
5. Player submits identity form
6. Server:

   * Saves identity data
   * Sets player name
   * Gives starter pack
7. Done ✅

---

## 📌 Callbacks & Events

### 📥 Server Callbacks

* `lavan_identity:getWhitelistData` → Fetch whitelist data + Discord avatar
* `lavan_identity:checkAlreadyRegistered` → Check if player is already registered

### 📤 Server Events

* `lavan_identity:saveIdentity` → Save identity data + give starter pack

---

## 🧠 Requirements

* ESX Framework
* MySQL (oxmysql or mysql-async)

### Required Table: `lavan_whitelist`

Must include:

* `discord_id`
* `firstname`
* `lastname`
* `dob`
* `gender`
* `height`

---

## 🚀 Use Cases

* Roleplay (RP) servers
* Whitelisted servers
* Identity + starter system

---

## ⚠️ Notes

* Make sure your Discord Bot has permission to access user data
* Keep your Bot Token **private**
* Ensure Discord identifiers are enabled in your FiveM server
