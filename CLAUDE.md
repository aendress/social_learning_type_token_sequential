# Project rules

## Project files
- code/social_learning_type_token_sequential.Rmd: Experiment generation
- code/social_learning_type_token_sequential_results.Rmd: Analyses
- paper/type_token_sequential_paper5.tex: Submitted paper
- paper/type_token_sequential_paper_r1.tex: Revision in progress

## Context
- 

---

## R code style

### Explicit package calls
Always use explicit `package::function()` calls. Never use unqualified function names from non-base packages. Examples:
- `dplyr::mutate()` not `mutate()`
- `stringr::str_detect()` not `str_detect()`
- `ggplot2::ggplot()` not `ggplot()`

### Idiomatic tidyverse
- Use `dplyr::mutate()`, `dplyr::filter()`, `dplyr::select()` etc. for data manipulation
- Use `tidyr::pivot_longer()` / `tidyr::pivot_wider()` (not `gather()`/`spread()`)
- Use `purrr::map()` family instead of `lapply()`/`sapply()`
- Use `purrr::map_dfr()` / `purrr::pmap_dfr()` to iterate and bind results into a data frame
- Use `purrr::reduce(dplyr::left_join, by = ...)` to join a list of data frames
- Use `purrr::list_rbind()` to bind a list of data frames
- Use `dplyr::case_when()` for conditional assignments instead of nested `ifelse()`
- Use `dplyr::across()` with `dplyr::where()` or selection helpers for column-wise operations
- Use `tibble::tribble()` for structured inline data entry (e.g. file manifests, parameter grids)
- Pipe with `%>%`
- Functions that operate on a piped data frame should use `function(dat = .)` — never `function(.)` with `. %>% ...` in the body, as magrittr will interpret `. %>%` as a functional sequence rather than piping the parameter value

### R utility library
Source `~/R.ansgar/ansgarlib/R/tt.R` conditionally based on user, and source project helper files if present. See reference code section below.

Key functions from `tt.R`:

**Statistical tests**
- `wilcox.p(x, mu = 0, add.descriptives = FALSE)` — Wilcoxon signed-rank test; returns formatted p-value. Use inside `dplyr::summarize()` to add p-values to descriptive tables.
- `t.test.p(x, mu = 0)` — one-sample t-test; returns formatted p-value
- `tt4(x, m = 0)` — formatted one-sample t-test output: M, SD, t, p, Cohen's d, CI
- `cor2(x, y)` — Pearson correlation with t-statistic and p-value
- `calculate.pairwise.wilcoxon.tests(data, condition.pairs, paired = TRUE)` — pairwise Wilcoxon tests with optional multiple-comparison correction
- `report.aov(...)` — extracts and prints ANOVA results with partial eta-squared
- `extract.results.from.model(mod)` — fixed effects, SE, CI, t from `lmer` model
- `extract.results.from.binary.model(model)` — estimates and odds ratios from binary GLMMs

**Effect sizes / signal detection**
- `d_cohen(x, y)` — Cohen's d between two groups
- `dprime(hit, fa)` — d′ sensitivity; `aprime(hit, fa)` — non-parametric A′

**Descriptives and data utilities**
- `se(x)` — standard error of the mean
- `get.demographics2(dat, subj, gender, age, ...)` — demographics summary (N, % female, age M/range) with optional grouping
- `summarySE(data, measurevar, groupvars)` — N, mean, SD, SE, CI by groups
- `get.median.split(x)` — binary variable by median split
- `v2z(v)` — standardize vector to z-scores
- `read.files.in.dir(directory, extension, sep, ...)` — reads all matching files from a directory into one data frame

**Bad subject / outlier detection**
- `find.bad.subj.by.binom.test(df, n.trials, alternative)` — subjects below chance by binomial test
- `get.min.number.of.correct.trials.by.binom.test(n.trials, alternative)` — minimum correct trials for significance
- `clean.data.by.factors(df, data.col, factor.names, remove.threshold)` — removes outliers within factor combinations (MAD or SD)

**Table utilities**
- `kable.packed(dat, index.col, ...)` — `knitr::kable` with `kableExtra::pack_rows` grouping; pass the grouping column name as a string
- `make.pack.index(x)` — creates the `index` argument for `kableExtra::pack_rows` from a vector (run-length encoding)
- `en_math_col_names(dat, excluded_cols)` — wraps column names containing `_`, `^`, or `\` in LaTeX `$...$`
- `replace_default_column_labels(X)` — replaces common column names (M, SE, p.value, etc.) with LaTeX-formatted versions
- `kable.packed.for.binary.model(dat, index.col, ...)` — packed kable for binary GLMM results (log-odds + odds ratios)
- `make.linesep.for.kable(n)` — generates `linesep` for `knitr::kable` to add spacing every n rows

**Plotting**
- `violin_plot_template(p = ., yintercept = 0, add.dot.plot = TRUE, add.mean.cl.boot = TRUE)` — violin + dot plot + bootstrapped mean CI; pipe a ggplot object into it
- `add_sig_labels(p, dat.sig.summary, y.offset)` — adds significance stars above groups in violin plots
- `add_sig_stars(dat, p_col)` — adds a `sig` column with `***`/`**`/`*`/`.`/`ns` from a p-value column
- `title_case_labeller(labels)` — title-case labeller for `ggplot2::facet_*`
- `clearpage()` — outputs `\clearpage` for LaTeX page breaks between sections

### Package loading
Use `librarian::shelf()` in a single organized block with inline comments for package purpose. Commented-out packages are kept for reference. See reference code section below.

### knitr setup chunk
Standard global chunk options at the top of every document. See reference code section below.

### ggplot2 theme
Set a global theme once in the setup chunk; do not repeat per plot:
```r
ggplot2::theme_set(ggthemes::theme_clean(14))
theme_update(legend.position = "bottom", legend.justification = "center")
```
Use `latex2exp::TeX()` for mathematical notation in axis labels.

### Violin plots
Prefer `violin_plot_template()` from the utility library to visualize distributions and central tendencies. Combine panels with `ggpubr::ggarrange()`:
```r
dat %>%
    ggplot2::ggplot(ggplot2::aes(x = condition, y = score)) %>%
    violin_plot_template(yintercept = 0.5)

ggpubr::ggarrange(plot_a, plot_b, nrow = 1, labels = "auto",
                  common.legend = TRUE, legend = "bottom")
```

### Tables (kableExtra)
- Always pass `booktabs = TRUE` to `knitr::kable()`
- Always finish the pipeline with `kableExtra::kable_classic2()` — it compiles correctly to both PDF and HTML
- Use `kableExtra::add_header_above(..., bold = TRUE)` for grouped column headers
- For long tables add `longtable = TRUE` and `escape = FALSE`
- Use `kable.packed("grouping_col", ...)` when rows group by a variable; use `tidyr::unite()` to build the grouping column when the group spans multiple variables

### Statistical tests: reporting alongside descriptives
When testing against a chance/null level, report descriptives and the test p-value in the same table:
```r
dat %>%
    dplyr::group_by(condition) %>%
    dplyr::summarize(
        N  = dplyr::n(),
        M  = mean(score),
        SE = se(score),
        p  = wilcox.p(score, mu = 0.5)
    ) %>%
    knitr::kable(caption = "Descriptives", booktabs = TRUE, escape = FALSE) %>%
    kableExtra::kable_classic2()
```

### Global parameters
Organise all file paths in a `LOCATIONS` list and all analysis parameters in a `PARAMS` list at the top of the document. Each `PARAMS` entry has a `description` field and a `values` field (scalar or named list per experiment). Use `make_params_table(PARAMS)` to render them. See reference code section below.

## Safety copies
Before modifying any file, save a timestamped safety copy:
```r
file.copy("path/to/file.R", paste0("path/to/file.R.", format(Sys.time(), "%Y%m%d_%H%M%S")))
```
Or in bash: `cp file.R file.R.$(date +%Y%m%d_%H%M%S)`

After completing a task for which a safety copy was made, verify that the only differences between the modified file and its safety copy are the intended edits (e.g. using `diff file.R file.R.<timestamp>`).

---

## Reference code

### Sourcing utility library and helper files
```r
if (Sys.info()[["user"]] %in% c("ansgar", "endress")) {
    source("/Users/endress/R.ansgar/ansgarlib/R/tt.R")
} else {
    source("http://endress.org/progs/tt.R")
}

list.files(path = HELPER_DIR, pattern = "\\.[Rr]$", full.names = TRUE) %>%
    purrr::walk(source)
```

### Package loading
```r
librarian::shelf(
    tidyverse,
    knitr,
    kableExtra,
    ggthemes,
    ggpubr,
    lme4
    # rstatix,
    # latex2exp,
)
```

### knitr setup chunk
```r
options(digits = 3, knitr.kable.NA = "")
knitr::opts_chunk$set(
    eval = TRUE, echo = FALSE, warning = FALSE, error = FALSE,
    message = FALSE, include = TRUE, tidy = FALSE,
    fig.align = "center", out.width = "80%"
)
knitr::opts_knit$set(kable.force.latex = TRUE)
```

### LOCATIONS and PARAMS
```r
LOCATIONS <- list(
    data     = list(exp1 = file.path("..", "data", "exp1", "results.txt")),
    bad_subj = list(exp1 = file.path("..", "data", "exp1", "badSubj.txt")),
    output_dir_figs = "figs/"
)

PARAMS <- list(
    REMOVEBADSUBJ = list(
        description = "Whether to remove bad subjects",
        values      = TRUE
    ),
    MAX_RT = list(
        description = "Maximum RT in seconds",
        values      = list(exp1 = 10, exp2 = 7.5)
    )
)
make_params_table(PARAMS)
```

### kable pipelines
```r
# Standard
dat %>%
    knitr::kable(caption = "...", booktabs = TRUE, longtable = TRUE, escape = FALSE) %>%
    kableExtra::add_header_above(c(" " = 1, "Group" = 2), bold = TRUE) %>%
    kableExtra::kable_classic2()

# Grouped rows
dat %>%
    tidyr::unite(pack_col, group1, group2, sep = " - ") %>%
    kable.packed("pack_col", caption = "...", booktabs = TRUE,
                 longtable = TRUE, escape = FALSE) %>%
    kableExtra::kable_classic2()
```
