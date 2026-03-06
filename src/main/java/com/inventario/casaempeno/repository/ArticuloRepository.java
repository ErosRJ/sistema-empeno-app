package com.inventario.casaempeno.repository;

import com.inventario.casaempeno.model.Articulo;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ArticuloRepository extends JpaRepository<Articulo, Long> {
    List<Articulo> findByIdCliente(Long idCliente);
    }