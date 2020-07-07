#!groovy
// -*- mode: groovy -*-

build('damsel', 'docker-host') {
    checkoutRepo()
    loadBuildUtils()

    def pipeDefault
    def gitUtils
    runStage('load pipeline') {
        env.JENKINS_LIB = "build_utils/jenkins_lib"
        pipeDefault = load("${env.JENKINS_LIB}/pipeDefault.groovy")
        pipeJavaProto = load("${env.JENKINS_LIB}/pipeJavaProto.groovy")
        gitUtils = load("${env.JENKINS_LIB}/gitUtils.groovy")
    }

    pipeDefault() {

        runStage('compile') {
            sh "make wc_compile"
        }

        // Erlang
        runStage('Generate Erlang lib') {
          sh "make wc_release-erlang"
        }
        if (env.BRANCH_NAME == 'master' || env.BRANCH_NAME.startsWith('epic/')) {
          runStage('Publish Erlang lib') {
            dir("_release/erlang") {
              gitUtils.push(commitMsg: "Generated from commit: $COMMIT_ID \n\non $BRANCH_NAME in $RBK_REPO_URL\n\nChanges:\n$COMMIT_MSG",
                            files: "*", branch: "release/erlang/$BRANCH_NAME", orphan: true)
            }
          }
        }
    }
    pipeJavaProto()
}
