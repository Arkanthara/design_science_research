How real-time visualization is a game changer !
The Lattice Boltzmann Method enables real-time visualization of fluid simulations through GPU parallelization thanks to a relevant representation of the fluid

Water is something that fascinate humans for a long time.
Indeed, Archimedes was already using the properties of fluids for calculations such as the famous legend in which he determined the purity of gold in a crown using the properties of a fluid.
Nowadays, technology has made huge advances, allowing to better understand behavior of fluids thanks to complex simulations.
These simulations are very computationally intensive and require high-end hardware.
However, the development of GPUs (Graphics Processing Unit) and parallel computing on GPUs is making this type of simulation more accessible to a wider audience, particularly in the fields of visual effects, video games, etc.

In general, simulations take place in two stages: computation, then visualization.
Due to the complexity of the calculations, parallelizing fluid simulation is very difficult to achieve, especially on GPUs, which are highly specialized components designed to process large amounts of data in parallel by applying the same calculations to different parts of the data, as is the case in image and video processing, for example. %which have a specific structure that only accepts certain types of tasks but offer high computing power. %which are highly specialized components designed to process large amounts of data in parallel by applying the same calculations to different parts of the data, as is the case in image and video processing, for example.
That's why most methods perform parallelization on CPUs (central processing units) rather than GPUs due to the complexity of exploiting parallelization on GPUs.

Some approaches that enable both visualization and computation by exploiting parallelization on GPUs have already been implemented, such as the method based on NVIDIA's GVDB Voxel technology , which uses the specific architecture of NVIDIA GPUs to perform computation and visualization in parallel.
Other methods, designed more for visual results than for simulation realism, have been developed, particularly in game engines such as Fluid Flux for Unreal Engine.
The proposed method will attempt to address the challenges posed by GPU parallelization and fluid simulation in a novel way, using fluid modeling that facilitates GPU usage.

The new method developed, called the Lattice Boltzmann Method (LBM), is not based on the famous Navier-Stokes equations, which represent the flow of a viscous fluid.
Indeed, these equations are very complex and have no known mathematical solution to date: the Navier-Stokes equations are among the \textit{Millennium Prize Problems} for which a reward of one million dollars is offered to anyone who can solve them.
The approach used is derived from the \textit{Lattice Gaz Automata} method developed in 1973 by J. Hardy, Y. Pomeau, and O. Pazzis \cite{Hardy1973TimeEO}, which uses Boltzmann equations instead of Navier-Stokes equations.
In contrast to the Navier-Stokes equations, which describe the behavior of fluids at a macroscopic level, Boltzmann's equations use a microscopic representation of the fluid in the form of a set of populations of particles that interact with each other as shown on figure.

As in Boltzmann's equations, the LBM method defines a distribution function $f$ that describes the number of particles at position $f$ at time $t$ moving in direction $\xi$ at velocity $i$.
The parameter $\xi$ can be defined as $i$.
The main difference here is that the LBM method works with particle populations instead of considering each particle separately, which is computationally intensive.
The distribution function $f$ is normalized such that integration over velocity and position gives the mass of the population, as shown in equation (\ref{eq:mass}), to ensure that the Euler's principle of conservation of mass is respected.
Indeed, when the velocity and position of each particle are neglected, only the mass of the population remains.

Calculating the moments of the distribution function $f$ enables the characteristics of the fluid to be extracted, such as the particle density $\rho$ for moment 0 or the momentum $\rho u$ for moment 1.
The function $f$ evolves over time as described in equation (\ref{eq:evolution}), in accordance with Newton's second law.
As shown in Figure \ref{fig:propagation}, the algorithm operates in two main steps: collision calculation, followed by propagation of the result to neighboring particle populations.
In this way, interactions are local and can be exploited for GPU parallelization.
The implementation, benchmarks, documentation, and examples are available on ProjectPhysX/FluidX3D on GitHub \cite{Lehmann_FluidX3D_2022}.
GPU parallelization is effective and enables realistic real-time rendering of fluid simulations, as shown in Figure \ref{fig:ex1}.
For more complex cases, the simulation can be run on multiple GPUs from different manufacturers, as shown in Figure \ref{fig:ex2}.
However, real-time visualization is not possible and the simulation must be saved.

In conclusion, by approaching fluid simulation from a different angle, the Lattice Boltzmann Method allows for extensive parallelization of fluid simulation across multiple GPUs, with the possibility of real-time visualization when running on a single GPU.
A next step could be to enable real-time simulation rendering on multiple GPUs, or to use a sparse volumetric representation of the data on the GPU to enable simulation with an adaptive domain and increase simulation efficiency by using less data on the GPU, or to implement the Lattice Boltzmann method in 3D software such as Blender.