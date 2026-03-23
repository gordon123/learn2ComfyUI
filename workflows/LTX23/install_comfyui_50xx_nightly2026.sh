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
    echo "💡 Please run: สร้าง virtual venv ใหม่ คำสั่ง python -m venv venv"
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
if [ -d "ComfyUI" ]; then
    echo "📂 ComfyUI folder already exists. Skipping clone..."
    cd ComfyUI
else
    echo "🚀 Cloning ComfyUI..."
    git clone https://github.com/comfyanonymous/ComfyUI.git
    cd ComfyUI || exit
fi

# --- 1. Install Torch (CUDA 13 - Nightly Version) ---
echo "🔥 Installing PyTorch (CUDA 13 Nightly)..."
echo "   (Selecting 'Nightly' for maximum RTX 50-series performance)"

# ใช้ --pre เพื่อดึงตัว Nightly และชี้ไปที่ index-url ของ cu130
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu130 --no-cache-dir

# ติดตั้ง requirements หลักของ ComfyUI
echo "📦 Installing ComfyUI Requirements..."
pip install -r requirements.txt

# --- 2. Install Custom Nodes ---
echo "✨ Installing Custom Nodes..."
mkdir -p custom_nodes # สร้างโฟลเดอร์กันเหนียว
cd custom_nodes || exit

# Function to clone and install requirements (Smart Install) 🧠
install_node() {
    repo_url=$1
    folder_name=$(basename "$repo_url" .git)
    
    if [ -d "$folder_name" ]; then
        echo "⏭️  $folder_name already exists. Skipping..."
    else
        echo "⬇️ Downloading: $folder_name"
        git clone "$repo_url"
        
        if [ -f "$folder_name/requirements.txt" ]; then
            echo "   💊 Installing dependencies for $folder_name..."
            pip install -r "$folder_name/requirements.txt"
        fi
    fi
}

# [1] ComfyUI Manager (Must Have)
install_node "https://github.com/Comfy-Org/ComfyUI-Manager.git"

# [2] ComfyUI-RunpodDirect (RunPod Tool)
# install_node "https://github.com/MadiatorLabs/ComfyUI-RunpodDirect.git"

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
