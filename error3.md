Running Gradle task 'assembleDebug'...                             892ms
[!] Gradle threw an error while downloading artifacts from the network.
Retrying Gradle Build: #1, wait time: 100ms
Exception in thread "main" java.io.FileNotFoundException: https://github.com/gradle/gradle-distributions/releases/download/v8.9.1/gradle-8.9.1-bin.zip
        at java.base/sun.net.www.protocol.http.HttpURLConnection.getInputStream0(Unknown Source)
        at java.base/sun.net.www.protocol.http.HttpURLConnection.getInputStream(Unknown Source)
        at java.base/sun.net.www.protocol.https.HttpsURLConnectionImpl.getInputStream(Unknown Source)
        at org.gradle.wrapper.Download.downloadInternal(Download.java:58)
        at org.gradle.wrapper.Download.download(Download.java:44)
        at org.gradle.wrapper.Install$1.call(Install.java:61)
        at org.gradle.wrapper.Install$1.call(Install.java:48)
        at org.gradle.wrapper.ExclusiveFileAccessManager.access(ExclusiveFileAccessManager.java:65)
        at org.gradle.wrapper.Install.createDist(Install.java:48)
        at org.gradle.wrapper.WrapperExecutor.execute(WrapperExecutor.java:128)
        at org.gradle.wrapper.GradleWrapperMain.main(GradleWrapperMain.java:61)
Running Gradle task 'assembleDebug'...                             831ms
[!] Gradle threw an error while downloading artifacts from the network.
Error: Gradle task assembleDebug failed with exit code 1
PS C:\HabitV8> 