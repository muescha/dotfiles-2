function __fish_right_prompt_k8s_context -d "Show the kubectl current context after running the `k` alias"
    [ -z "$KUBECTL_PROMPT_ICON" ]; and set -l KUBECTL_PROMPT_ICON "ﴱ"
    [ -z "$KUBECTL_PROMPT_SEPARATOR" ]; and set -l KUBECTL_PROMPT_SEPARATOR /
    set -l config $KUBECONFIG
    [ -z "$config" ]; and set -l config "$HOME/.kube/config"
    if [ ! -f $config ]
        echo (set_color red --bold)$KUBECTL_PROMPT_ICON" "(set_color normal)"no config "
        return
    end

    set -l ctx (kubectl config current-context 2>/dev/null)
    if [ $status -ne 0 ]
        echo (set_color red --bold)$KUBECTL_PROMPT_ICON" "(set_color normal)"no context "
        return
    end

    set -l ns (kubectl config view -o "jsonpath={.contexts[?(@.name==\"$ctx\")].context.namespace}")
    [ -z $ns ]; and set -l ns default

    echo (set_color $fish_prompt_color_k8s)$KUBECTL_PROMPT_ICON" "(set_color normal)"$ctx$KUBECTL_PROMPT_SEPARATOR$ns "
end
