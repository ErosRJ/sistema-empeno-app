package com.inventario.casaempeno.repository;


import com.inventario.casaempeno.model.Deuda;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DeudaRepository extends JpaRepository<Deuda, Long> {
    List<Deuda> findByIdCliente(Long idCliente);
}
