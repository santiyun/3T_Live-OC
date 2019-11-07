### 连麦直播

**TTTLive**是Swift演示demo  **TTTLive-OC**是OC演示demo 

#### 准备工作
1. 下载[TTTRtcEngineKit.framework](https://github.com/santiyun/iOS-LiveSDK) 和 [TTTPlayerKit.framework](https://github.com/santiyun/iOS-LiveSDK)。 放在**TTTLib**目录下
2. 登录三体云[官网](http://dashboard.3ttech.cn/index/login) 注册体验账号，进入控制台新建自己的应用并获取APPID。


#### demo SDK使用方式：

1. 该demo使用链接framework的方式，参考other link flags

2. 在framework search path添加framework路径

3. 添加系统库：

> 1. libc++.tbd
> 2. libxml2.tbd
> 3. libz.tbd
> 4. ReplayKit.framework
> 5. CoreTelephony.framework
> 6. SystemConfiguration.framework

4. 设置 bitcode=NO

5. 选择后台音频模式

