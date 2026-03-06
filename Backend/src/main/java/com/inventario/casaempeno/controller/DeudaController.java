package com.inventario.casaempeno.controller;


import com.inventario.casaempeno.model.Deuda;
import com.inventario.casaempeno.repository.DeudaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/deudas")
@CrossOrigin("*")
public class DeudaController {

    @Autowired
    private DeudaRepository deudaRepository;

    @PostMapping("/add")
    public Deuda addDeuda(@RequestBody Map<String, Object> payload) {
        Deuda d = new Deuda();

        Object monto = payload.get("monto");
        if (monto != null) {
            try { d.setMonto(Double.parseDouble(monto.toString())); } catch (Exception ignored) { d.setMonto(0.0); }
        } else d.setMonto(0.0);

        Object estado = payload.get("estado");
        d.setEstado(estado != null ? estado.toString() : "pendiente");

        Object fecha = payload.get("fechaPago");
        d.setFechaPago(fecha != null ? fecha.toString() : LocalDate.now().toString());

        Object clienteObj = payload.get("cliente");
        if (clienteObj instanceof Map) {
            Object idObj = ((Map<?, ?>) clienteObj).get("id");
            if (idObj != null) {
                try { d.setIdCliente(Long.parseLong(idObj.toString())); } catch (Exception ignored) {}
            }
        } else if (payload.get("idCliente") != null) {
            try { d.setIdCliente(Long.parseLong(payload.get("idCliente").toString())); } catch (Exception ignored) {}
        }

        Object articuloObj = payload.get("articulo");
        if (articuloObj instanceof Map) {
            Object idObj = ((Map<?, ?>) articuloObj).get("id");
            if (idObj != null) {
                try { d.setIdArticulo(Long.parseLong(idObj.toString())); } catch (Exception ignored) {}
            }
        } else if (payload.get("idArticulo") != null) {
            try { d.setIdArticulo(Long.parseLong(payload.get("idArticulo").toString())); } catch (Exception ignored) {}
        }

        return deudaRepository.save(d);
    }

    @GetMapping("/list")
    public List<Deuda> listAll() {
        return deudaRepository.findAll();
    }

    @GetMapping("/cliente/{idCliente}")
    public List<Deuda> listByCliente(@PathVariable Long idCliente) {
        return deudaRepository.findByIdCliente(idCliente);
    }

    @PutMapping("/pagar/{deudaId}")
    public Object pagar(@PathVariable Long deudaId, @RequestBody(required = false) Object body) {
        Optional<Deuda> opt = deudaRepository.findById(deudaId);
        if (opt.isEmpty()) return Map.of("error", "Deuda no encontrada");

        Deuda d = opt.get();
        Double pago = null;

        if (body instanceof Number) {
            pago = ((Number) body).doubleValue();
        } else if (body instanceof Map) {
            Object m = ((Map<?, ?>) body).get("montoPago");
            if (m instanceof Number) pago = ((Number) m).doubleValue();
            else if (m != null) {
                try { pago = Double.parseDouble(m.toString()); } catch (Exception ignored) {}
            }
        } else if (body != null) {
            try { pago = Double.parseDouble(body.toString()); } catch (Exception ignored) {}
        }

        if (pago == null || pago <= 0) return Map.of("error", "Monto inválido");

        double nuevo = d.getMonto() - pago;
        d.setMonto(nuevo < 0 ? 0.0 : nuevo);
        if (d.getMonto() <= 0.0) d.setEstado("pagada"); else d.setEstado("parcial");

        Deuda saved = deudaRepository.save(d);
        return saved;
    }
}
