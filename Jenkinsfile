pipeline {
    agent any
    // options {
    //     // Timeout counter starts AFTER agent is allocated
    //     timeout(time: 1, unit: 'SECONDS')
    // }
    stages {
        stage('Infrastructure') {
            steps {
                sleep 100
                echo 'Hello World'
                error 'Intentional failure'
                // echo "salam hhhh"
            }
        }
    }
}
