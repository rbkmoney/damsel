#!groovy

// Args:
// GitHub repo name
// Jenkins agent label
// Tracing artifacts to be stored alongside build logs
pipeline("damsel", 'docker-host', "_build/") {

  runStage('compile') {
    sh "make w_container_compile"
  }

  // Build failed without this file: _build/test/logs/index.html (Hi, jenkins_pipeline_lib)
  runStage('folder_create') {
    sh "make w_container_create"
  }

  if (env.BRANCH_NAME == 'master') {
      runStage('deploy_nexus') {
        sh "make w_container_deploy_nexus"
      }
  } else {
      runStage('java_compile') {
        sh "make w_container_java_compile"
      }
  }

}
