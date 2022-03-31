runSimulations <- function(n_sim, policy, version_probs = VERSION_PROBS, sim_length = 100, policy_params = NULL) {
    map_df(seq(n_sim), ~{
        simulateRun(policy, version_probs, sim_length, policy_params) |> mutate(run = .x)
    })
}

simulateRun <- function(policy, version_probs = VERSION_PROBS, sim_length = 100, policy_params = NULL) {
    history <- createEmptyHistory()
    while (nrow(history) < sim_length) {
        show_next <- applyPolicy(policy, history, version_probs, policy_params)
        history <- updateHistory(history, show_next, version_probs)
    }
    history
}

applyPolicy <- function(policy, history, version_probs, policy_params) {
    if (nrow(history) < 4) {
        seq_along(version_probs)
    } else {
        n_versions <- length(version_probs)
        switch(policy,
            RCT = applyPolicyRCT(history, n_versions),
            ETC = applyPolicyETC(history, n_versions, policy_params),
            epsGreedy = applyPolicyEpsGreedy(history, n_versions, policy_params),
            UCB = applyPolicyUCB(history)
        )
    }
}

applyPolicyRCT <- function(history, n_versions) {
    getShowedVersion("random", history, n_versions)
}

applyPolicyGreedy <- function(history) {
    getShowedVersion("exploit", history)
}

applyPolicyETC <- function(history, n_versions, policy_params) {
    if (!"explore_until" %in% names(policy_params)) {
        stop("The policy ETC needs a parameter explore_until in policy_params")
    }
    if (nrow(history) <= policy_params$explore_until) {
        applyPolicyRCT(history, n_versions)
    } else if (nrow(history) == policy_params$explore_until + 1) {
        applyPolicyGreedy(history)
    } else (
        getShowedVersion("last_action", history)
    )
}

applyPolicyEpsGreedy <- function(history, n_versions, policy_params) {
    if (!"epsilon" %in% names(policy_params)) {
        stop("The policy epsGreedy needs a parameter epsilon in policy_params")
    }
    if (runif(1) <= policy_params$epsilon) {
        applyPolicyRCT(history, n_versions)
    } else {
        applyPolicyGreedy(history)
    }
}

applyPolicyUCB <- function(history) {
    getShowedVersion("ucb", history)
}

getShowedVersion <- function(rule, history, n_versions = NULL) {
    switch(rule,
        exploit = history |>
            group_by(showed_version) |> 
            summarize(expected_conversion = mean(conversion)) |> 
            filter(expected_conversion == max(expected_conversion)) |>
            slice_sample(n = 1) |>
            pull(showed_version),
        random = sample(seq(n_versions), 1),
        last_action = tail(history, 1) |> pull(showed_version),
        ucb = calculateUCBIndices(history) |>
            filter(index == max(index)) |>
            slice_sample(n = 1) |>
            pull(showed_version)
    )
}

updateHistory <- function(history, showed_versions, version_probs) {
    add_row(history,
        i = seq(nrow(history) + 1, nrow(history) + length(showed_versions)),
        showed_version = showed_versions, 
        conversion = realizeConversion(showed_versions, version_probs)
    )
}

realizeConversion <- function(showed_versions, version_probs) {
    rbinom(length(showed_versions), 1, version_probs[showed_versions])
}

createEmptyHistory <- function() {
    tibble(i = numeric(), showed_version = numeric(), conversion = numeric())
}

calculateUCBassignment <- function(history) {
    calculateUCBIndices(history) |>
        filter(index == max(index)) |>
        slice_sample(n = 1) |>
        pull(showed_version)
}

calculateUCBIndices <- function(history) {
    group_by(history, showed_version) |>
        summarise(mean = mean(conversion), n = n()) |>
        mutate(index = mean + calculateUCBConfidenceWidth(n, sum(n)) * mean * (1 - mean))
}

calculateUCBConfidenceWidth <- function(n, n_k) {
    sqrt(2 * log(1 + n * log(n)^2) / n_k)
}
