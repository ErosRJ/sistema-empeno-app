package com.inventario.casaempeno.model;


import jakarta.persistence.*;

@Entity
@Table(name = "articulos")
public class Articulo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // para simplicidad guardamos id del cliente (no object relation)
    private Long idCliente;

    private String fechaEmpeno;

    private String tipoArticulo;

    private String estado;

    private Double valorEstimado;

    // Getters y Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getIdCliente() { return idCliente; }
    public void setIdCliente(Long idCliente) { this.idCliente = idCliente; }

    public String getFechaEmpeno() { return fechaEmpeno; }
    public void setFechaEmpeno(String fechaEmpeno) { this.fechaEmpeno = fechaEmpeno; }

    public String getTipoArticulo() { return tipoArticulo; }
    public void setTipoArticulo(String tipoArticulo) { this.tipoArticulo = tipoArticulo; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public Double getValorEstimado() { return valorEstimado; }
    public void setValorEstimado(Double valorEstimado) { this.valorEstimado = valorEstimado; }
}
