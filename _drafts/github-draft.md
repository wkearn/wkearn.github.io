---
layout: post
title: Long live GitHub!
tags:
- julia
- matlab
- github
- arid landscapes
---
#### Why do I keep using MATLAB? ####

Simple answer: because it's what I was taught. In the couple of undergrad courses I took that involved any computation (such as Ocean-Atmosphere Dynamics taught by [Irina Marinov](http://www.sas.upenn.edu/earth/marinov.html)) we used MATLAB. When I set out last summer to get more familiar with numerical methods and scientific programming, I just kept using it. I toyed around with implementing some spatial ecological models such as the arid vegetation model developed by HilleRisLambers et al. 2001.[^2] And when I got to BU and started taking our Quantitative Methods course, MATLAB was the language of choice. Now for better or worse, MATLAB is my fast-prototyping language: I can get models up and running on MATLAB pretty darn quickly.

Of course, MATLAB is proprietary, and we computational scientists want to be nice and share code with everyone who wants it, right? So maybe MATLAB isn't the best language to be writing all of my models in. Yet for some unknown reason, I've never really been able to get into or [Octave](http://www.gnu.org/software/octave/index.html) or [Python](http://www.numpy.org) (though I did set up [IPython](http://ipython.org) last week. The notebooks are really neat, so maybe Python will happen in the future). But this week I found something that I could get into.

#### Enter Julia ####

Through a complicated maze of hyperlinks and procrastination earlier this week, I discovered [Julia](http://julialang.org). Julia's main goal is to get the performance that you see in C or Fortran -- which I learned earlier this year through BU's [Scientific Computing and Visualization tutorials](http://www.bu.edu/tech/about/training/classroom/scv-tutorials/) -- with the ease of use of dynamic languages like MATLAB and Python. Well, this sounds great! Let's figure it out, and by "figure it out" I mean "implement the HilleRisLambers model in it."

#### Tiger Bush! ####

The model relies on the diffusion operator on periodic boundary conditions, which I don't particularly like to implement over and over again. In MATLAB I got around this by creating a function called `perlap()` which looks like this:

	function V = perlap(U,dx)
	lap = 1/dx^2.*[0 1 0; 1 -4 1; 0 1 0];
	V = conv2(padarray(U,[1 1], 'circular'), lap, 'valid');

	
Nice and easy, right? I basically turn the five-point stencil for the Laplacian into a matrix and then convolve that stencil with the matrix representing our domain. To handle the periodic boundaries, I pad that matrix with MATLAB's `padarray()` function so as to represent the periodic boundaries. I'm sure it's not the best way to do things, but it works.

When I put the rest of the model into MATLAB with a real simple forward Euler scheme, I get something that looks like this:
![MATLAB. R=1.0, dx=dy=5.0, dt = 0.1, other parameters as given in Rietkerk et al. 2002]({{site.baseurl}}/images/matlab.png)

Hey, hey! We've made [tiger bush](http://en.wikipedia.org/wiki/Tiger_bush), the spotted or banded pattern of vegetation common in arid regions.

Now we want to do the same thing in Julia (check out this [GitHub repository](https://github.com/wkearn/hillerislambers) for the code). The first thing I have to do is figure out how to implement the diffusion operator without the `padarray()` and `conv2()` functions which come from MATLAB. Well, I ran into a similar problem in Fortran, so I already had worked out the algorithms to do each of those, and I just translated them into Julia. I then translated the MATLAB script I had used for the model earlier. The two languages are very similar: the biggest problem I had was remembering that Julia's matrix indices go in brackets, not parentheses.

If we crank the model, we get:

![Julia. Same parameters as in the MATLAB version]({{site.baseurl}}/images/julia.png)

Looks pretty good. I still need to figure out the intricacies of gnuplot or plotting from Julia in general.

I really like Julia. It does all of the things I might want to do in MATLAB but with the added benefit of being free and open source. It's a little rough around the edges, but that's kind of part of the allure at the moment: that I might actually be able to think of and implement something that Julia needs.

I'll keep working on that.

#### GitHub is just great ####

As I was experimenting with Julia, I quickly ran into [GitHub](http://www.github.com) since most of the Julia maintenance happens there. Of course I knew what git and GitHub are: I'd been half-assedly using git for a while now. But seeing the [Julia community](https://github.com/JuliaLang) on GitHub really showed me how powerful these tools can be. It also led me to discover [Jekyll](http://jekyllrb.com), a tool for generating websites from plain text. I promptly migrated my own website into Jekyll, and I think I'll detail that process in the next post.

[^2]: HilleRisLambers, R., Rietkerk, M.G., Bosch, F. van den, Prins, H.H.T. & Kroon, H. de (2001). Vegetation pattern formation in semi-arid grazing systems. *Ecology*, 82. 50-61. 
