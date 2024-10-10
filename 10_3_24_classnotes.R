## ------------------------------------------------------------------------------------------------------------------------
library(tidyverse)
library(praise)


## ------------------------------------------------------------------------------------------------------------------------

##**Debugging** What happens when something goes wrong with your code?


## ------------------------------------------------------------------------------------------------------------------------
library("reprex")

#Asking for help on a forum

  (y <- 1:4)
  mean(y)
## ------------------------------------------------------------------------------------------------------------------------
# Write a bit of code and copy it to the clipboard:

#Enter reprex() in the R Console.
  #In RStudio, you’ll see a preview of your rendered reprex.
       # (y <- 1:4)
       #> [1] 1 2 3 4
       #mean(y)
       #> [1] 2.5
       #Created on 2024-10-09 with reprex v2.1.1
## ------------------------------------------------------------------------------------------------------------------------
#| warning: true
log(-1)

#Warning message:  In log(-1) : NaNs produced

#This warning lets you know that taking the log of a negative
#number results in a NaN value because you can’t take the log of negative numbers.
#base our function log.
#If you provide a negative input in this case,
#R will tell you "I think this function is not gonna work as well"
#with a warning that says like some, not a numbers "NaNs" were produced.
#So this is for you to be aware of: later on in your code,
#you might have to filter out not a numbers NaNs

l <- log(c(-1, 5, 10))

#Produces: Warning message: In log(c(-1, 5, 10)) : NaNs produced

mean(l)

#[1] NaN

#The mean doesn't work by itself. Right? Remove the the things that are not numbers.
#Make sure that I use this.you use "na.rm = TRUE" argument
#you're okay with some observations were not compatible
#not a number NaNs.
#ignore those and find the mean for the rest of them.

mean(l, na.rm = TRUE)

#[1] 1.956012

## ------------------------------------------------------------------------------------------------------------------------
# This next function is taking a value of X,
#saying if it's greater than 0, print X is greater than 0.
#If it isn't less than or equal to 0, return X in an invisible way,
#such that like it does not automatically get printed into the output

#Returning an object invisibly means that
#the return value does not get auto-printed
#when the function is called.

print_message <- function(x) {
    if (x > 0) {
        print("x is greater than zero")
    } else {
        print("x is less than or equal to zero")
    }
    invisible(x)
}


## ------------------------------------------------------------------------------------------------------------------------
#| error: true
print_message(1)
#Returns message [1] "x is greater than zero"

## ------------------------------------------------------------------------------------------------------------------------
#| error: true
print_message(NA)

#Returns Error in if (x > 0) { : missing value where TRUE/FALSE needed

#What happened? The first thing the function does is test if x > 0.
#But you can’t do that test if x is a NA or NaN value.
#R doesn’t know what to do in this case so it stops with a fatal error.

#We can fix this problem by anticipating the possibility of
#NA values and checking to see if the input is NA with the is.na() function.
#The code is not written in a way that it can handle NAs or missing observations
#We need to edit the function

#Use the "is.na" function for for this, and edit the "if"
#to have, at the very 1st if else's "if" and check "is this an NA.
# Use the term "X is a missing value".

## ------------------------------------------------------------------------------------------------------------------------
print_message2 <- function(x) {
    if (is.na(x)) {
        print("x is a missing value!")
    } else if (x > 0) {
        print("x is greater than zero")
    } else {
        print("x is less than or equal to zero")
    }
    invisible(x)
}


## ------------------------------------------------------------------------------------------------------------------------
print_message2(NA)

#Returns [1] "x is a missing value!"

## ------------------------------------------------------------------------------------------------------------------------
#Cases with longer inputs than expected

#| error: true
x <- log(c(-1, 2))

#Returns Warning message:In log(c(-1, 2)) : NaNs produced

print_message2(x)
#Returns Error in if (is.na(x)) { : the condition has length > 1

#Why are we getting this warning?
#The problem here is that I passed
#print_message2() a vector x that was of length 2 rather then length 1.

#"ifs" can only handle a true or a false,
#they cannot handle a vector, of more options.

#Inside the body of print_message2() the expression is.na(x)
#returns a vector that is tested in the "if statement.

#However, "if" cannot take vector arguments, so you get a warning.

#We can solve this problem two ways.

#Simply not allow vector arguments.
#The other way is to vectorize the print_message2() function to
#allow it to take vector arguments.

#For the first way (not allow vector arguments),
#we simply need to check the length of the input

## ------------------------------------------------------------------------------------------------------------------------
print_message3 <- function(x) {
    if (length(x) > 1L) {
        stop("'x' has length > 1")
      #Add an if the length of X is greater than one
      #at that point.We don't know what to do here, just gonna stop completely.
      #The stop function prints an error message.
    }
    if (is.na(x)) {
        print("x is a missing value!")
    } else if (x > 0) {
        print("x is greater than zero")
    } else {
        print("x is less than or equal to zero")
    }
    invisible(x)
}


## ------------------------------------------------------------------------------------------------------------------------
#| error: true
#Now when we pass print_message3() a vector, we should get an error.

print_message3(1:2)

#Returns Error in print_message3(1:2) : 'x' has length > 1

#This is a more informative error message

## ------------------------------------------------------------------------------------------------------------------------
#Don’t show users the call to help them and you too!
#Setting call. = FALSE when using stop() and/or warning()
#helps your users by providing them less information that could confuse them.

print_message3_no_call <- function(x) {
    if (length(x) > 1L) {
        stop("'x' has length > 1", call. = FALSE)
    }
    if (is.na(x)) {
        print("x is a missing value!")
    } else if (x > 0) {
        print("x is greater than zero")
    } else {
        print("x is less than or equal to zero")
    }
    invisible(x)
}


## ------------------------------------------------------------------------------------------------------------------------
#| error: true
print_message3_no_call(99:100)

#Returns Error: 'x' has length > 1

print_message3(99:100)

#Returns Error in print_message3(99:100) : 'x' has length > 1

#The second scenario doesn’t include information that only we (as the user) have.
#As the person trying to help users, knowing how the users called our function
#is very likely not useful enough information.

#But this is not enough to know what needs to be debugged
#A reprex is much better!!!!!

## ------------------------------------------------------------------------------------------------------------------------
# Errors in the tidyverse

#If you want to write error messages similar to those you are used to seeing with
#tidyverse packages, use rlang.
#Specifically, switch:

#base::stop() with rlang::abort()

#base::warning() with rlang::warn()

#base::message() with rlang::inform()
## ------------------------------------------------------------------------------------------------------------------------

print_message3_tidyverse <- function(x) {
    if (length(x) > 1L) {
        rlang::abort("'x' has length > 1")
    }
    if (is.na(x)) {
        rlang::warn("x is a missing value!")
    } else if (x > 0) {
        rlang::inform("x is greater than zero")
    } else {
        rlang::inform("x is less than or equal to zero")
    }
    invisible(x)
}


## ------------------------------------------------------------------------------------------------------------------------
#| error: true
print_message3_tidyverse(99:100)

#Returns:
              #Error in `print_message3_tidyverse()`:
              #! 'x' has length > 1
              #Run `rlang::last_trace()` to see where the error occurred.

#This uses exclamation point to say, "this"print_message3_tidyverse"
#is the source of the error.
#And then it puts gray "If you want to know where the error is
#run this thing called our length last trace,  and it'll provide you like a little bit more information

print_message3_tidyverse(NA)
#Returns
          #Warning message:
           #x is a missing value!

print_message3_tidyverse(1)
#Returns
        #x is greater than zero

print_message3_tidyverse(-1)

#Returns
        #x is less than or equal to zero

## ------------------------------------------------------------------------------------------------------------------------
#R developers use cli to make their error messages super pretty to read
#use cli::cli_abort() instead of rlang::abort()

#This is an example of cli::

print_message3_cli <- function(x) {
    if (length(x) > 1L) {
        len <- length(x)

        ## Avoid the print() calls from
        ## https://github.com/ComunidadBioInfo/praiseMX/blob/master/R/praise_crear_emi.R
        praise_mx_log <- capture.output({
            praise_mx <- praiseMX:::praise_bien()
        })
        cli::cli_abort(
            c(
                "This function is not vectorized:",
                "i" = "{.var x} has length {len}.",
                "x" = "{.var x} must have length 1.",
                ">" = "Try using {.code purrr::map(x, print_message3_cli)} to loop your input {.var x} on this function.",
                "v" = praise::praise(),
                "v" = praise_mx
            )
        )
    }
    if (is.na(x)) {
        rlang::warn("x is a missing value!")
    } else if (x > 0) {
        rlang::inform("x is greater than zero")
    } else {
        rlang::inform("x is less than or equal to zero")
    }
    invisible(x)
}


## ------------------------------------------------------------------------------------------------------------------------
#| error: true
set.seed(20230928)
print_message3_cli(-1:1)

#Error in `print_message3_cli()`:
  #! This function is not vectorized:
  #ℹ `x` has length 3.
#✖ `x` must have length 1.
#→ Try using `purrr::map(x, print_message3_cli)` to loop your input `x` on this
#function.
#✔ You are neat!
 # ✔ ¡Ah chingá! Programas bien perrón.

purrr::map(-1:1, print_message3_cli)


## ------------------------------------------------------------------------------------------------------------------------
#Vectorizing
#Vectorizing the function can be accomplished easily
#We take a version that already handle the #NAs and
#vectorize it without having to think too much about
#how to handle inputs of of length greater than one

#with the Vectorize() function.

print_message4 <- Vectorize(print_message2)
out <- print_message4(c(-1, 2))

#Returns [1] "x is less than or equal to zero"  and [1] "x is greater than zero
#You can see that these correct messages are printed without any warning or error.

## ------------------------------------------------------------------------------------------------------------------------
#| error: true

#Debugging Tools in R

#Primary tools for debugging functions in R:
#traceback():  debug:; browser():; trace():; and recover()

#Example: Let’s use the mean() function on a vector z
#that does not exist in our R environment

mean(z)
#Returns Error in mean(z) : object 'z' not found

traceback()
#Returns 1: mean(z)
#Here, it’s clear that the error
#occurred inside the mean() function because the object z does not exist.
#The traceback() function must be called immediately after an error occurs.
#Once another function is called, you lose the traceback.

#Here is slightly more complicated example
#using the lm() function for linear modeling

lm(y ~ x)
#Returns Error in eval(predvars, data, env) : object 'y' not found

traceback()
#Returns
#7: eval(predvars, data, env)
#6: eval(predvars, data, env)
#5: model.frame.default(formula = y ~ x, drop.unused.levels = TRUE)
#4: stats::model.frame(formula = y ~ x, drop.unused.levels = TRUE)
#3: eval(mf, parent.frame())
#2: eval(mf, parent.frame())
#1: lm(y ~ x)
#The error did not get thrown until the 7th level of the function call stack,
#in which case the eval() function tried to evaluate the formula y ~ x
#and realized the object y did not

#If instead we used
rlang::global_entrace()
lm(y ~ x)

#Returns: Error: ! object 'y' not found
#Run `rlang::last_trace()` to see where the error occurred.

rlang::last_error()

#Returns: Backtrace:▆
#1. └─stats::lm(y ~ x)
#2.   └─base::eval(mf, parent.frame())
#3.     └─base::eval(mf, parent.frame())

#Looking at the traceback is useful for figuring out roughly
#where an error occurred but it’s not useful for more detailed debugging.
#For that you might turn to the debug() function.

## ----error=TRUE----------------------------------------------------------------------------------------------------------
#Try using traceback() to debug this piece of code:

f <- function(a) g(a)
g <- function(b) h(b)
h <- function(c) i(c)
i <- function(d) {
    if (!is.numeric(d)) {
        stop("`d` must be numeric", call. = FALSE)
    }
    d + 10
}
f("a")

## ------------------------------------------------------------------------------------------------------------------------
#| error: true
"hello" + "world"


## ------------------------------------------------------------------------------------------------------------------------
#| warning: true
as.numeric(c("5", "6", "seven"))


## ------------------------------------------------------------------------------------------------------------------------
#| message: true
f <- function() {
  message("This is a message.")
}

f()


## ------------------------------------------------------------------------------------------------------------------------
suppressMessages(f())


## ------------------------------------------------------------------------------------------------------------------------
#| message: true
f2 <- function() {
  message(Sys.time(), " This is a message.")
}

f2()


## ------------------------------------------------------------------------------------------------------------------------

#Handling ERRORS

#| error: true

stop("Something erroneous has occurred!")


## ------------------------------------------------------------------------------------------------------------------------
#| error: true
name_of_function <- function() {
  stop("Something bad happened.")
}

name_of_function()


## ------------------------------------------------------------------------------------------------------------------------
#| error: true
error_if_n_is_greater_than_zero <- function(n) {
  stopifnot(n <= 0)
  n
}

error_if_n_is_greater_than_zero(5)


## ------------------------------------------------------------------------------------------------------------------------
#| error: true
error_if_n_squared <- function(n) {
  ## Ok use
  stopifnot(n <= 0)

  ## Create an internal object
  n_squared <- n^2

  ## Not ok, since we are using the internal object n_squared
  stopifnot(n_squared <= 10)
  n
}

error_if_n_squared(-2)

## This generates a confusing error message to our users
error_if_n_squared(-4)


## ------------------------------------------------------------------------------------------------------------------------
#| error: true
fn <- function(x = c("foo", "bar")) {
  x <- rlang::arg_match(x)

  ## Known scenario 1
  if (x == "foo") {
    print("I know what to do here with 'x = foo'")
  }

  ## Known scenario 2
  if (x == "bar") {
    print("I know what to do here with 'x = bar'")
  }
}
fn("foo")
fn("zoo")


## ------------------------------------------------------------------------------------------------------------------------
#| warning: true
warning("Consider yourself warned!")


## ------------------------------------------------------------------------------------------------------------------------
#| warning: true
make_NA <- function(x) {
  warning("Generating an NA.")
  NA
}

make_NA("Sodium")


## ------------------------------------------------------------------------------------------------------------------------
message("In a bottle.")


## ------------------------------------------------------------------------------------------------------------------------
as.numeric(c("5", "6", "seven"))


## ------------------------------------------------------------------------------------------------------------------------
beera <- function(expr) {
  tryCatch(expr,
           error = function(e) {
             message("An error occurred:\n", e)
           },
           warning = function(w) {
             message("A warning occured:\n", w)
           },
           finally = {
             message("Finally done!")
           }
  )
}


## ------------------------------------------------------------------------------------------------------------------------
beera({
  2 + 2
})

beera({
  "two" + 2
})

beera({
  as.numeric(c(1, "two", 3))
})


## ----error=TRUE----------------------------------------------------------------------------------------------------------
is_even <- function(n) {
  n %% 2 == 0
}

is_even(768)

is_even("two")


## ------------------------------------------------------------------------------------------------------------------------
is_even_error <- function(n) {
  tryCatch(n %% 2 == 0,
           error = function(e) {
             FALSE
           }
  )
}

is_even_error(714)

is_even_error("eight")


## ------------------------------------------------------------------------------------------------------------------------
is_even_check <- function(n) {
  is.numeric(n) && n %% 2 == 0
}

is_even_check(1876)

is_even_check("twelve")


## ------------------------------------------------------------------------------------------------------------------------
#| eval: false
## library(microbenchmark)
## microbenchmark(sapply(letters, is_even_check))


## ----eval=FALSE----------------------------------------------------------------------------------------------------------
## microbenchmark(sapply(letters, is_even_error))


## ------------------------------------------------------------------------------------------------------------------------
options(width = 120)
sessioninfo::session_info()

