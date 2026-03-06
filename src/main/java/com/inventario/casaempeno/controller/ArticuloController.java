package com.inventario.casaempeno.controller;


import com.inventario.casaempeno.model.Articulo;
import com.inventario.casaempeno.repository.ArticuloRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/articulos")  // <-- Agregado /api
@CrossOrigin("*")
public class ArticuloController {

    @Autowired
    private ArticuloRepository articuloRepository;

    @PostMapping("/add")
    public Articulo addArticulo(@RequestBody Map<String, Object> payload) {
        Articulo a = new Articulo();

        Object tipo = payload.get("tipoArticulo");
        if (tipo != null) a.setTipoArticulo(tipo.toString());

        Object estado = payload.get("estado");
        if (estado != null) a.setEstado(estado.toString());

        Object valor = payload.get("valorEstimado");
        if (valor != null) {
            try { a.setValorEstimado(Double.parseDouble(valor.toString())); } catch (Exception ignored) { a.setValorEstimado(0.0); }
        } else a.setValorEstimado(0.0);

        Object clienteObj = payload.get("cliente");
        if (clienteObj instanceof Map) {
            Object idObj = ((Map<?, ?>) clienteObj).get("id");
            if (idObj != null) {
                try { a.setIdCliente(Long.parseLong(idObj.toString())); } catch (Exception ignored) {}
            }
        } else if (payload.get("idCliente") != null) {
            try { a.setIdCliente(Long.parseLong(payload.get("idCliente").toString())); } catch (Exception ignored) {}
        }

        a.setFechaEmpeno(LocalDate.now().toString());
        return articuloRepository.save(a);
    }

    @GetMapping("/list")
    public List<Articulo> listAll() {
        return articuloRepository.findAll();
    }

    @GetMapping("/cliente/{idCliente}")
    public List<Articulo> listByCliente(@PathVariable Long idCliente) {
        return articuloRepository.findByIdCliente(idCliente);
    }

    @DeleteMapping("/{id}")
    public Map<String, String> delete(@PathVariable Long id) {
        articuloRepository.deleteById(id);
        return Map.of("msg", "Eliminado");
    }
}
