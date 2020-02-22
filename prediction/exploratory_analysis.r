
tt_correlation_matrix <- function (dataset, independent_variable ) {
  #collects required data from the dataset
  orig_names <- colnames(dataset)
  n_cols <- dim(dataset)[2]
  cor_vector <- numeric( n_cols - 1 )
  
  #fetch the column with the independent variable
  y <- as.numeric(dataset[[independent_variable]])
  n <- 1
  #loop over all the columns, and calculate the correlation with the independent variable
  for ( i in 1:n_cols ) {
    if ( independent_variable != orig_names[i] && is.numeric(y) ) {
      cor_vector[n] <- cor(y , as.numeric(dataset[, i]))
      names(cor_vector)[n] <- orig_names[i]
      n <- n + 1
    }
  }
  
  #sort by absolute value of correlation
  cor_vector <- cor_vector[order(abs(cor_vector), na.last = TRUE, decreasing = TRUE)] 
  #output
  cor_vector
}


tt_plot_cor <- function (dataset, independent_variable ) {
  cor <- tt_correlation_matrix(dataset, independent_variable)
  max_corr <- min( length(cor), 3)
  
  # 1 predictor: 2d plot
  if (1 == max_corr ) {
    y_values = as.numeric ( dataset[[independent_variable]] )
    x_values = as.numeric( dataset[[names(cor)[1]]] )
    p <- plot_ly(dataset, x = x_values, y = y_values ) %>%
      add_markers() %>%
      layout(scene = list(xaxis = list(title = names(cor)[1]),
                          yaxis = list(title = independent_variable)))
  } 
  
  #2 predictors: 3d plot
  if (2 == max_corr ) {
    z_values = dataset[[independent_variable]]
    x_values = dataset[[names(cor)[1]]]
    y_values = dataset[[names(cor)[2]]]
    p <- plot_ly(dataset, x = x_values, y = y_values, z =z_values) %>%
      add_markers() %>%
      layout(scene = list(xaxis = list(title = names(cor)[1]),
                          yaxis = list(title = names(cor)[2]),
                          zaxis = list(title = independent_variable)))
  }
  
  #3 predictors (max): 3d with color
  if (3 == max_corr ) {
    z_values = dataset[[independent_variable]]
    x_values = dataset[[names(cor)[1]]]
    y_values = dataset[[names(cor)[2]]]
    colors = dataset[[names(cor)[3]]]
    
    p <- plot_ly(dataset, x = x_values, y = y_values, z = z_values, color = colors, colors = c('#BF382A', '#0C4B8E')) %>%
      add_markers()  %>%
      layout(scene = list(xaxis = list(title = names(cor)[1]),
                          yaxis = list(title = names(cor)[2]),
                          zaxis = list(title = independent_variable)),
             annotations = list(
               x = 1.13,
               y = 1.05,
               text = names(cor)[3],
               xref = 'paper',
               yref = 'paper',
               showarrow = FALSE
             ))
  } 
  #output plot
  p
}