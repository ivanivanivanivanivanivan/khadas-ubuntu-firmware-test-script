#!/bin/bash

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "\e[1;36m🎉 欢迎使用由李豪开发的硬件测试脚本 🎉\e[0m"
echo -e "\e[1;33m准备开始您的硬件测试之旅吧！\e[0m"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# eMMC 性能测试函数
emmc_test() {
    echo "开始eMMC性能测试..."
    sudo iozone -e -I -a -s 100M -r 4k -r 16k -r 512k -r 1024k -r 16384k -i 0 -i 1 -i 2
    echo "eMMC性能测试完成。"
}

# TF卡分区和性能测试函数
tf_partition() {
    echo "请插入TF卡，然后按Enter继续..."
    read -p ""

    echo "当前分区信息如下："
    sudo fdisk -l

    read -p "请确认TF卡分区路径 (例如：/dev/mmcblk1): " tf_card_path

    if [ ! -b "$tf_card_path" ]; then
        echo "错误：找不到分区路径 $tf_card_path，请确认设备已插入并重试。"
        exit 1
    fi

    echo "开始对 $tf_card_path 进行分区..."
    (
        echo d
        echo p
        echo g
        echo n
        echo
        echo
        echo
        echo w
    ) | sudo fdisk "$tf_card_path"

    echo "TF卡分区完成。"

    tf_partition_path="${tf_card_path}p1"
    echo "格式化分区 $tf_partition_path 为 FAT 文件系统..."
    sudo mkfs.vfat "$tf_partition_path"

    mount_point="/mnt"
    echo "挂载 $tf_partition_path 到 $mount_point ..."
    sudo mount "$tf_partition_path" "$mount_point"

    echo "进入挂载目录 $mount_point 进行性能测试..."
    cd "$mount_point"
    sudo iozone -e -I -a -s 100M -r 4k -r 16k -r 512k -r 1024k -r 16384k -i 0 -i 1 -i 2

    echo "性能测试完成，卸载分区 $tf_partition_path..."
    cd /
    sudo umount "$mount_point"

    echo "TF卡性能测试完成。"
}

# USB 3.0移动硬盘分区和性能测试函数
usb2_0_performance() {
    echo "请在USB 2.0端口上插入移动硬盘，然后按Enter继续..."
    read -p ""

    echo "当前USB设备信息如下："
    lsusb

    # 获取 USB 设备信息
    lsusb_info=$(lsusb)

    # 检查是否在 Bus 002 上检测到包含 "SSD" 的设备
    if echo "$lsusb_info" | grep -q "Bus 001" && echo "$lsusb_info" | grep -q "SSD"; then
        zenity --info --text="检测到在 USB 2.0 上的 SSD 设备。"
    else
        zenity --error --text="未检测到在 USB 2.0 上的 SSD 设备，请检查连接。"
        exit 1
    fi

    echo "当前分区信息如下："
    sudo fdisk -l

    read -p "请确认移动硬盘分区路径 (例如：/dev/sda): " usb_disk_path

    if [ ! -b "$usb_disk_path" ]; then
        echo "错误：找不到分区路径 $usb_disk_path，请确认设备已插入并重试。"
        exit 1
    fi

    echo "开始对 $usb_disk_path 进行分区..."
    (                                                                                           
        echo d
        echo p
        echo g
        echo n
        echo
        echo
        echo
        echo w
    ) | sudo fdisk "$usb_disk_path"

    usb_partition="${usb_disk_path}1"
    echo "格式化分区 $usb_partition 为 ext4 文件系统..."
    sudo mkfs.ext4 "$usb_partition"

    mount_point="/mnt"
    echo "挂载 $usb_partition 到 $mount_point ..."
    sudo mount "$usb_partition" "$mount_point"

    echo "进入挂载目录 $mount_point 进行性能测试..."
    cd "$mount_point"
    sudo iozone -e -I -a -s 100M -r 4k -r 16k -r 512k -r 1024k -r 16384k -i 0 -i 1 -i 2

    echo "性能测试完成，卸载分区 $usb_partition..."
    cd /
    sudo umount "$mount_point"

    echo "USB 2.0移动硬盘性能测试完成。"
}

# USB 3.0移动硬盘分区和性能测试函数
usb3_0_performance() {
    echo "请在USB 3.0端口上插入移动硬盘，然后按Enter继续..."
    read -p ""

    echo "当前USB设备信息如下："
    lsusb

    # 获取 USB 设备信息
    lsusb_info=$(lsusb)

    # 检查是否在 Bus 002 上检测到包含 "SSD" 的设备
    if echo "$lsusb_info" | grep -q "Bus 002" && echo "$lsusb_info" | grep -q "SSD"; then
        zenity --info --text="检测到在 USB 3.0 上的 SSD 设备。"
    else
        zenity --error --text="未检测到在 USB 3.0 上的 SSD 设备，请检查连接。"
        exit 1
    fi

    echo "当前分区信息如下："
    sudo fdisk -l

    read -p "请确认移动硬盘分区路径 (例如：/dev/sda): " usb_disk_path

    if [ ! -b "$usb_disk_path" ]; then
        echo "错误：找不到分区路径 $usb_disk_path，请确认设备已插入并重试。"
        exit 1
    fi

    echo "开始对 $usb_disk_path 进行分区..."
    (
        echo d
        echo p
        echo g
        echo n
        echo
        echo
        echo
        echo w
    ) | sudo fdisk "$usb_disk_path"

    usb_partition="${usb_disk_path}1"
    echo "格式化分区 $usb_partition 为 ext4 文件系统..."
    sudo mkfs.ext4 "$usb_partition"

    mount_point="/mnt"
    echo "挂载 $usb_partition 到 $mount_point ..."
    sudo mount "$usb_partition" "$mount_point"

    echo "进入挂载目录 $mount_point 进行性能测试..."
    cd "$mount_point"
    sudo iozone -e -I -a -s 100M -r 4k -r 16k -r 512k -r 1024k -r 16384k -i 0 -i 1 -i 2

    echo "性能测试完成，卸载分区 $usb_partition..."
    cd /
    sudo umount "$mount_point"

    echo "USB 3.0移动硬盘性能测试完成。"
}

# SSD 读写性能测试函数
ssd_performance() {
    # 检查是否存在 nvme0n1 节点
    if [ ! -e "/dev/nvme0n1" ]; then
        zenity --error --text="未检测到 nvme0n1 节点，请在断电状态下将 SSD 插入 M.2 接口后重试。\n注意：SSD 不支持热插拔。"
        exit 1
    else
        zenity --info --text="检测到 M.2 SSD (nvme0n1)。将进行测试环境配置..."
    fi

    # 更新系统并安装 fio
    zenity --info --text="更新系统并安装 fio 工具..."
    sudo apt update && sudo apt install -y fio

    # 执行写入测试
    zenity --info --text="开始 SSD 写入测试..."
    sudo fio --filename=/dev/nvme0n1 --direct=1 --iodepth=4 --thread=1 --rw=write --ioengine=libaio --bs=1M --size=200G --numjobs=30 --runtime=60 --group_reporting --name=my

    zenity --info --text="SSD 写入测试完成。"
}

test_gsensor() {
    echo "正在检测 G-Sensor 节点..."

    # 检查是否存在 /dev/accel 节点
    if [ ! -e "/dev/accel" ]; then
        echo "G-Sensor 节点未注册，无法进行测试。"
        return 1
    else
        echo "检测到 G-Sensor 节点：/dev/accel"
    fi

    # 创建并写入 G-Sensor 测试的 C 代码
    cat << 'EOF' > gsensor_sample_demo.c
#include <stdio.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>

#define GBUFF_SIZE 12
#define GSENSOR_IOCTL_MAGIC 'a'
#define GSENSOR_IOCTL_INIT _IO(GSENSOR_IOCTL_MAGIC, 0x01)
#define GSENSOR_IOCTL_RESET _IO(GSENSOR_IOCTL_MAGIC, 0x04)
#define GSENSOR_IOCTL_CLOSE _IO(GSENSOR_IOCTL_MAGIC, 0x02)
#define GSENSOR_IOCTL_START _IO(GSENSOR_IOCTL_MAGIC, 0x03)
#define GSENSOR_IOCTL_GETDATA _IOR(GSENSOR_IOCTL_MAGIC, 0x08, char[GBUFF_SIZE+1])
#define GSENSOR_IOCTL_APP_SET_RATE _IOW(GSENSOR_IOCTL_MAGIC, 0x10, short)
#define GSENSOR_IOCTL_GET_CALIBRATION _IOR(GSENSOR_IOCTL_MAGIC, 0x11, int[3])

struct sensor_axis {
    int x;
    int y;
    int z;
};

char *gsensor_device = "/dev/accel";
int gsensor_fd = -1;

int main(int argc, char **argv) {
    struct sensor_axis gsensor_data;
    gsensor_fd = open(gsensor_device, O_RDWR);

    if (0 > gsensor_fd) {
        printf("gsensor node open failed ...\n");
        exit(-1);
    } else {
        printf("gsensor node open success!!!\n");
    }

    if (ioctl(gsensor_fd, GSENSOR_IOCTL_START, NULL) == -1) {
        printf("gsensor start failed ...\n");
        close(gsensor_fd);
        exit(-1);
    } else {
        printf("gsensor start success !!!\n");
    }

    printf("start to get gsensor data ...\n");
    while (1) {
        if (ioctl(gsensor_fd, GSENSOR_IOCTL_GETDATA, &gsensor_data) == -1) {
            printf("gsensor get data failed ...\n");
            close(gsensor_fd);
            exit(-1);
        }
        printf("gsensor_data -- x:%d, y:%d, z:%d \n", gsensor_data.x, gsensor_data.y, gsensor_data.z);
        sleep(1);
    }

    close(gsensor_fd);
    return 0;
}
EOF

    # 编译 G-Sensor 测试程序
    echo "编译 G-Sensor 测试程序..."
    gcc -o gsensor_sample_demo gsensor_sample_demo.c
    if [ $? -ne 0 ]; then
        echo "编译失败，请检查编译环境。"
        return 1
    else
        echo "编译成功，开始执行 G-Sensor 测试程序..."
    fi

    # 执行 G-Sensor 测试程序
    ./gsensor_sample_demo
}

install__docker() {
    echo "开始安装 Docker..."

    # 更新和安装系统包
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl

    # 创建和添加存储 Docker GPG 密钥
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    # 安装 Docker 和相关组件
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "进行 Docker 验证测试......"
    sudo docker run hello-world

    if [ $? -eq 0 ]; then
        echo "Docker 安装和测试成功！"
    else
        echo "Docker 测试失败，请记录log信息到测试用例。"
    fi
}

#hardware_decoding() {
#	echo "请连接以太网，然后等待5秒，再按Enter继续..."
#    read -p ""
	
#    echo "开始进行硬件解码测试..."

#	echo "正在下载视频文件：bbb_sunflower_1080p_60fps_normal.mp4..."
#    sshpass -p 'khadas' scp khadas@192.168.31.72:/home/khadas/Videos/bbb_sunflower_1080p_60fps_normal.mp4 . || { echo "文件下载失败，请参考文档，手动进行测试。"; exit 1; }

#    echo "正在下载视频文件：4K_6.1_2012.mkv..."
#	sshpass -p 'khadas' scp khadas@192.168.31.72:/home/khadas/Videos/4K_6.1_2012.mkv . || { echo "文件下载失败，请参考文档，手动进行测试。"; exit 1; }

#    gst-launch-1.0 filesrc location=./bbb_sunflower_1080p_60fps_normal.mp4 ! qtdemux name=d d.video_0 ! h264parse ! v4l2h264dec ! video/x-raw,format=NV12 ! amlvenc ! h264parse ! filesink location=/home/khadas/h264dec.h264
#}



# 检查参数并选择功能
case "$1" in
    emmc)
        emmc_test
        ;;
    tfcard)
        tf_partition
        ;;
    usb2.0)
        usb2_0_performance
        ;;
	usb3.0)
        usb3_0_performance
		;;
	ssd)
        ssd_performance
		;;
    gsensor)
	    test_gsensor
		;;
    docker)
        install__docker 
		;;
        *)
        echo "用法: $0 {emmc|tfcard|usb2.0|...}"
        echo "emmc      - 进行eMMC性能测试"
        echo "tfcard    - 进行TF卡分区和性能测试"
        echo "usb2.0    - 进行USB 2.0移动硬盘分区和性能测试"
		echo "usb3.0    - 进行USB 3.0移动硬盘分区和性能测试"
		echo "ssd       - 进行SSD性能测试"
		echo "gsensor   - 进行G-Sensor功能测试"
		echo "docker    - 进行Docker安装和测试"
        exit 1
        ;;
esac
