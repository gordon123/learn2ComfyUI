#!/bin/bash

# --- 0. Pre-Flight Check (Virtual Environment) ---
echo "🛑------------------------------------------------🛑"
echo "   ⚠️  WAIT A MINUTE! (เดี๋ยวก่อนวัยรุ่น!)"
echo "   Have you activated your Virtual Environment?"
echo "   (คุณได้ activate venv แล้วหรือยัง?)"
echo "🛑------------------------------------------------🛑"
read -p "👉 Type 'y' to continue or 'n' to stop (y/n): " choice

case "$choice" in 
  y|Y|yes|Yes ) 
    echo "✅ Awesome! Systems go. Initiating launch sequence..." 
    ;;
  n|N|no|No ) 
    echo "🚫 Script Aborted! (ยกเลิกภารกิจ)"
    echo "💡 Please run: สร้าง vertual venv ใหม่ คำสั่ง python -m venv venv"
    echo "💡 Please run: คำสั่งใช้งาน source venv/bin/activate"
    exit 1 
    ;;
  * ) 
    echo "❌ Invalid input. Exiting..."
    exit 1 
    ;;
esac

# -----------------------------------------------------
# เริ่มต้นกระบวนการติดตั้งปกติ
# -----------------------------------------------------

cd /workspace

# Clone ComfyUI
echo "🚀 Cloning ComfyUI..."
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI || exit

# --- 1. Install Torch (User Specified) ---
echo "🔥 Installing PyTorch (CUDA 12.6)..."
# ใช้ --no-cache-dir เพื่อประหยัดพื้นที่บน RunPod ถ้าจำเป็น
pip install --index-url https://download.pytorch.org/whl/cu126 \
  torch==2.7.0 torchvision==0.22.0 torchaudio==2.7.0

# ติดตั้ง requirements หลักของ ComfyUI
echo "📦 Installing ComfyUI Requirements..."
pip install -r requirements.txt

# --- 2. Install Custom Nodes ---
echo "✨ Installing Custom Nodes..."
cd custom_nodes || exit

# Function to clone and install requirements (Smart Install) 🧠
install_node() {
    repo_url=$1
    folder_name=$(basename "$repo_url" .git)
    
    echo "⬇️ Downloading: $folder_name"
    git clone "$repo_url"
    
    if [ -f "$folder_name/requirements.txt" ]; then
        echo "   💊 Installing dependencies for $folder_name..."
        pip install -r "$folder_name/requirements.txt"
    fi
}

# [1] ComfyUI Manager (Must Have)
install_node "https://github.com/Comfy-Org/ComfyUI-Manager.git"

# [2] ComfyUI-RunpodDirect (RunPod Tool)
install_node "https://github.com/MadiatorLabs/ComfyUI-RunpodDirect.git"

# [3] Civicomfy (Civitai Integration)
install_node "https://github.com/MoonGoblinDev/Civicomfy.git"

# [4] ComfyUI-KJNodes (Utility Tools)
install_node "https://github.com/kijai/ComfyUI-KJNodes.git"

# [5] rgthree-comfy (Optimization & UX)
install_node "https://github.com/rgthree/rgthree-comfy.git"

# ออกมานอก custom_nodes
cd ..

# --- 3. Launch Instructions ---
echo "✅ Installation Complete! (ติดตั้งเสร็จสิ้น)"
echo "------------------------------------------------"
echo "To launch, copy & run this:"
echo "cd /workspace/ComfyUI"
echo "python main.py --listen"
