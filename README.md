# SGD for nonlinear bandits
In this repository, we simulate SGD for noisy zeroth order optimization of ridge functions.
At each time $t$, the learner proposes an action $x_t \in \mathbb{S}^{d-1}$ and observes
$$y_t = f(\langle \theta^\star, a_t \rangle) + \varepsilon_t$$
where $\varepsilon_t \sim \mathcal{N} (0,1)$ is unobserved noise. In contrast with the interactive setting we consider, typically the actions $\{ a_t \}$ are assumed to be drawn i.i.d., and the learner does not control their choice. The form of SGD we consider incorporates some amount of exploration in the following manner: at each time $t$, the action played is,

$$a_t = \sqrt{1-\sigma_t^2}\theta_t + \sigma_t Z_t, \qquad Z_t\sim \mathrm{Unif} \big( \big\\{ a \in \mathbb{S}^{d-1}: \langle a, \theta_t \rangle = 0 \big\\} \big),$$

where the hyperparameter sequence $\sigma_t\in [0,1]$ governs the exploration-exploitation tradeoff. After playing the action $a_t$ and observing $y_t$, the parameter $\theta_t$ is updated as follows,

$$\theta_{t+1/2} = \theta_t - \eta_t (f(\langle \theta_t, a_t \rangle) - r_t) f^\prime (\langle \theta_t, a_t \rangle) \cdot (I-\theta_t\theta_t^\top) a_t, \quad \theta_{t+1} = \frac{\theta_{t+1/2}}{\\|\theta_{t+1/2}\\|_2}.$$

The algorithm will set the learning rate sequence, $\\{ \eta_t \\}$ and the exploration parameter sequence $\\{ \sigma_t \\}$ based on splitting the time horizon $[T]$ into a burn-in phase and a learning phase.

## Setting up the repository

cd to `bandit/` and run

```
chmod +x setup.sh
```

To make the setup script executable. Runs are executed in parallel across a single A100 GPU, or serially on CPU, the corresponding torch dependencies are installed via `setup.sh` into a conda environment called `bandit`. Execute

```
./setup.sh
```

You are now ready to execute `bandit-sim.ipynb`. The learning rate and sigma schedules in the learning phase are set "optimally" based on theoretical predictions. The choice of  `T_learning`, `sigma_learning_schedule` and 
`eta_learning_schedule` can be set in the notebook, which determine the length of the learning phase, as well as the learning rate and exploration parameter sequences for this phase.