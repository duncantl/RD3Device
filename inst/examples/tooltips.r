library(RD3Device)

dev = d3Device(file = "../../foo.js")
with(mtcars, plot(mpg ~ wt, col = c("red", "green", "blue")[factor(gear)],
                   xlab = "Weight", ylab = "Miles per gallon", cex = 2))

legend("topright",
        levels(factor(mtcars$gear)),
        pch = "o",
        col = c("red", "green", "blue"))
#    title = "number of gears"

abline(fit <- lm(mpg ~ wt, mtcars), lty = 2)
dev.off()

code = dev$getCode()
calls = dev$getCalls()

i = names(code) ==  "circle"
code[i] = mapply(function(code, id) {
             c(code, sprintf('el.append("svg:title").text("%s");', id))
       }, code[i], rownames(mtcars), SIMPLIFY = FALSE)


i = sapply(calls, function(x) "abline" %in% sapply(x, function(x) if(is.function(x[[1]])) "" else as.name(x[[1]])))
beta = coefficients(fit)
code[[which(i)]] = c(code[[which(i)]],
                      sprintf('el.append("svg:title").text("intercept = %.3f, slope = %.3f");', beta[1],beta[2]))


txt = sapply(code, function(x) attr(x, "text"))
i = txt == "Weight"
code[[which(i)]] = c(code[[which(i)]],
                      'el.append("svg:title").text("pounds/1000");')

i = txt == "Miles per gallon"
code[[which(i)]] = c(code[[which(i)]],
                      'el.append("svg:title").text("Miles/ US gallon");')

addToHTMLTemplate(code, "mtcars.html")
#cat(unlist(code), file = "../../foo.js", sep = "\n")

