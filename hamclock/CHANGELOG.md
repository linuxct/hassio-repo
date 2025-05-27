<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

## 1.0.3

- Replace healthcheck URL. Reason is service was believed to be degraded and caused a crash loop due to being unhealthy when hamclock is unconfigured. If hamclock runs is considered healthy. 
- Drastically reduce startup time (may solve [#1](https://github.com/linuxct/hassio-repo/issues/1))

## 1.0.2

Changed the path where the `hamclock` binary is executed from, as it gets 'installed' onto the container


## 1.0.1

Revert some changes that made 1.0.0 unusable. Change imagery


## 1.0.0

Initial release after some tests. Might be buggy still


## 0.0.1

Initial test release
