#!/bin/bash

# ============================================================
# 生电服务器优化启动脚本 (适用于 Java 21/25 + ZGC)
# ============================================================

# 指定 JVM 路径（根据你的路径设置）
JVM_PATH="./zulu25.30.17-ca-jdk25.0.1-linux_x64/bin/java"

# JVM 核心参数
JVM_OPTS="
    -Xms8G -Xmx8G                     # 将最小和最大内存设为一致，防止动态扩容导致瞬时卡顿
    -XX:+UseZGC                       # 启用 ZGC (低延迟垃圾回收器)
    -XX:+ZGenerational                # 启用分代 ZGC (Java 21+ 黑科技，大幅降低 CPU 消耗并提升效率)
    -XX:+AlwaysPreTouch               # 启动时预先分配物理内存，避免运行中向系统申请内存带来的延迟
    -XX:+DisableExplicitGC            # 禁用代码中手动触发的 GC，防止某些 Mod 或插件乱带节奏
    -XX:+UnlockDiagnosticVMOptions    # 解锁诊断选项，以便开启更多底层优化
    -XX:+UnlockExperimentalVMOptions  # 解锁实验性选项
    -XX:+UseLargePages                # 启用大页内存，减少 CPU 寻址开销 (需要系统层配合)
    -XX:+ExitOnOutOfMemoryError       # 内存溢出时立即退出并自动重启，防止服务器进入死锁状态
    -Dfile.encoding=UTF-8             # 强制使用 UTF-8 编码，防止 Mod 配置文件乱码
    -Dusing.zgc.optimized=true        # 自定义标记，方便识别当前使用的是 ZGC 配置
"

# 运行服务器
$JVM_PATH $JVM_OPTS -jar fabric-server-launch.jar nogui