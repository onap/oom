sudo -E minikube start --driver=none --kubernetes-version v1.15.11
sudo mv /home/ubuntu/.kube /home/ubuntu/.minikube $HOME
sudo chown -R $USER $HOME/.kube $HOME/.minikube
istioctl install --set profile=demo
git clone "https://gerrit.onap.org/r/oom" && (cd "oom" && mkdir -p .git/hooks && curl -Lo `git rev-parse --git-dir`/hooks/commit-msg https://gerrit.onap.org/r/tools/hooks/commit-msg; chmod +x `git rev-parse --git-dir`/hooks/commit-msg)
cd oom/
git pull "https://gerrit.onap.org/r/oom" refs/changes/67/108767/1
cd service-mesh/
helm init
helm serve &
chmod +x set_up.sh
sh set_up.sh